require './flask_set_shuffle.rb'
require './flask_set_generator.rb'

class FlaskSet
  include FlaskSetShuffle

  def initialize(flask_set = nil)
    @flask_set = flask_set || FlaskSetGenerator.call()
  end

  # class Node
  #   attributes :parent_node, :flask_set
  #   def initialize(parent_node = nil,)
  #   end
  # end

  def solve
    move = potential_moves.lazy.take(1)
    # Node.new()
  end

  def clone
    self.class.new(@flask_set.clone.map(&:clone))
  end

  def ==(other)
    self.snapshot == other.snapshot
  end

  def print
    @flask_set
  end

  def snapshot
    @flask_set.flatten.join
  end

  def inspect
    @flask_set.transpose.reverse.each do |row|
      p "%2d "*@flask_set.size % row
    end;nil
  end

  def solved?
    @flask_set.all? { |flask| monofilled?(flask) || empty?(flask) }
  end

private

  def potential_moves
    return @potential_moves if defined?(@potential_moves)

    @potential_moves = []
    @flask_set.each_with_index do |flask_from, flask_from_index|
      next if partially_monofilled?(flask_from) || monofilled?(flask_from) || empty?(flask_from)
      last_non_empty_index_from = last_non_empty_index(flask_from)
      from_index = [flask_from_index, last_non_empty_index_from]
      el = flask_from[last_non_empty_index_from]

      @flask_set.each_with_index do |flask_to, flask_to_index|
        next if flask_to_index == flask_from_index
        next if monofilled?(flask_to)
        if empty?(flask_to)
          @potential_moves << [from_index, [flask_to_index, 0]]
          next
        end
        last_non_empty_index_to = last_non_empty_index(flask_to)
        next if flask_to[last_non_empty_index_to] != el
        @potential_moves << [from_index, [flask_to_index, last_non_empty_index_to+1]]
      end
    end
    @potential_moves
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
end
