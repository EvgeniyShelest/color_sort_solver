require './flask_set_shuffle.rb'
require './flask_set_generator.rb'

class FlaskSet
  include FlaskSetShuffle

  @@count = 0
  @@level = 0

  class << self
    attr_writer :generator

    def generator
      @generator || FlaskSetGenerator.new
    end

    def reset_counters
      @@count = 0
      @@level = 0
    end
  end

  attr_reader :parent

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

  def print
    @flask_set
  end

  def inspect
    @flask_set.transpose.reverse.each do |row|
      p "%2d "*@flask_set.size % row
    end;nil
  end

  def solved?
    @flask_set.all? { |flask| monofilled?(flask) || empty?(flask) }
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
    from, to = indices
    @flask_set[to[0]][to[1]] = @flask_set[from[0]][from[1]]
    @flask_set[from[0]][from[1]] = 0
  end

  def repeated_state?
    current = self
    while(current = current.parent) do
      return true if current == self
    end
    false
  end

  def solve
    @@level += 1
    p count: @@count
    p level: @@level
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
      next if partially_monofilled?(flask_from) || monofilled?(flask_from) || empty?(flask_from)
      last_non_empty_index_from = last_non_empty_index(flask_from)
      from_index = [flask_from_index, last_non_empty_index_from]
      el = flask_from[last_non_empty_index_from]

      # detect best fitable flask to move to (sample [1,1,1,0])
      flask_to_index = @flask_set.find_index { |flask| flask == ([el]*(flask_capacity - 1) << 0) }
      if flask_to_index
        @potential_moves << [from_index, [flask_to_index, (flask_capacity - 1)]]
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
    flask[1..].all? { |el| el === flask[0] && !el.zero? }
  end

  def partially_monofilled?(flask)
    flask[1...-1].all? { |el| el === flask[0] && !el.zero? } && flask[-1].zero?
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
