require './flask_set_shuffle.rb'
require './flask_set_generator.rb'
require './utils/colorize.rb'

class FlaskSet
  include FlaskSetShuffle

  @@count = 0
  @@level = 0
  @@released = 0

  class << self
    attr_writer :generator

    def generator
      @generator || FlaskSetGenerator.new
    end

    def reset_counters
      @@count = 0
      @@level = 0
      @@released = 0
    end
  end

  attr_reader :parent, :from, :to

  def initialize(flask_set = nil, parent = nil)
    @flask_set = flask_set || self.class.generator.call()
    @parent = parent
    @@count += 1
  end

  def resolve
    self.class.reset_counters
    @potential_moves = nil
    solve
  end

  def inspect
    colorize = ->(str, moved) { moved ? str.bg_red : str }
    @flask_set.transpose.reverse.each_with_index do |row, i|
      row.each_with_index do |el, j|
        current_index = [j, flask_capacity - i - 1]
        moved = @from == current_index || @to == current_index
        next(print colorize.(" _ ", moved)) if el.zero?
        print colorize.("%2d " % el, moved)
      end
      print "\n"
    end;nil
  end

  def solved?
    res = @flask_set.all? { |flask| monofilled?(flask) || empty?(flask) }
    p "Moves amount: #{collect_solution_moves.size}" if res
    res
  end

  def add_empty_flask
    @flask_set << [0]*flask_capacity
  end

  def ==(other)
    self.snapshot == other.snapshot
  end

  protected

  def snapshot
    @flask_set.flatten.join
  end

  def do_move(indices)
    @from, @to = indices
    @flask_set[@to[0]][@to[1]] = @flask_set[@from[0]][@from[1]]
    @flask_set[@from[0]][@from[1]] = 0
  end

  def repeated_state?
    current = self
    while(current = current.parent) do
      return true if current == self
    end
    false
  end

  def collect_solution_moves
    solution_moves = []
    current = self
    while(current = current.parent) do
      solution_moves.unshift [current.from, current.to]
    end
    solution_moves
  end

  def solve
    @@level += 1
    p count: @@count
    p level: @@level
    p released: @@released
    return "SOLVED!" if solved?
    while(move_indices = potential_moves.shift) do
      child = clone
      child.do_move(move_indices)
      p do_move: move_indices
      child.inspect
      # to omit infinite loop detect if upstairs was already child state
      if child.repeated_state?
       p "repeated_state!  "*4
       child = nil
       @@released += 1
       next
      end
      if child.solved?
        return "SOLVED!"
      else
        res = child.solve
        return "SOLVED!" if res == "SOLVED!"
      end
    end
  end

  private

  def clone
    self.class.new(@flask_set.clone.map(&:clone), self)
  end

  def potential_moves
    return @potential_moves unless @potential_moves.nil?

    @potential_moves = []
    @flask_set.each_with_index do |flask_from, flask_from_index|
      next if most_partially_monofilled?(flask_from) || monofilled?(flask_from) || empty?(flask_from)
      last_non_empty_index_from = last_non_empty_index(flask_from)
      from_index = [flask_from_index, last_non_empty_index_from]
      el = flask_from[last_non_empty_index_from]

      # detect best fitable flask to move to (sample [1,1,1,0])
      flask_to_index = @flask_set.find_index { |flask| partially_monofilled_with?(flask, el) }
      if flask_to_index && flask_to_index != flask_from_index
        last_non_empty_index_to = last_non_empty_index(@flask_set[flask_to_index])
        @potential_moves << [from_index, [flask_to_index, last_non_empty_index_to + 1]]
        next
      end
      @flask_set.each_with_index do |flask_to, flask_to_index|
        next if flask_to_index == flask_from_index
        next if fullfilled?(flask_to)
        if empty?(flask_to)
          next if last_non_empty_index_from.zero? #omit senseless move from 0 index to 0 index
          @potential_moves << [from_index, [flask_to_index, 0]]
          next
        end
        last_non_empty_index_to = last_non_empty_index(flask_to)
        next if flask_to[last_non_empty_index_to] != el
        @potential_moves << [from_index, [flask_to_index, last_non_empty_index_to + 1]]
      end
    end
    @potential_moves
  end

  def fullfilled?(flask)
    flask.all? { |el| !el.zero? }
  end

  def monofilled?(flask)
    flask[1..].all? { |el| el === flask[0] } && !flask.empty?
  end

  def partially_monofilled?(flask)
    # flask.join.match(/^#{flask[0]}+0+/)  # [1, 1, 10, 4, 5 ] is false positive
    flask.join("|").match(/^(\|?#{flask[0]})+(\|0)+/) && !flask.empty?
  end

  def partially_monofilled_with?(flask, el)
    # flask.join.match(/^#{flask[0]}+0+/)  # [1, 1, 10, 4, 5 ] false positive
    flask.join("|").match(/^(\|?#{el})+(\|0)+/)
  end

  def most_partially_monofilled?(flask)
    partially_monofilled[flask[0]].max == flask
  end

  def partially_monofilled
    @partially_monofilled ||= @flask_set
      .select { |flask| partially_monofilled?(flask) }
      .reduce(Hash.new([])) { |acc, flask| acc[flask[0]] += [flask]; acc }
  end

  def empty?(flask)
    flask.all? { |el| el.zero? }
  end

  def last_non_empty_index(flask)
    flask.rindex { |el| !el.zero? }
  end

  def first_empty_index(flask)
    flask.find_index { |el| el.zero? }
  end

  def flask_capacity
    # this might be
    # self.class.generator.instance_variable_get(:@flask_capacity)
    # but we can change generator for class in runtime after set was created.
    @flask_set[0].size
  end
end
