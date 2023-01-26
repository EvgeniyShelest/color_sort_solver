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
    @flask_set.all? { |flask| monofilled_or_empty?(flask) }
  end

private

  def monofilled_or_empty?(flask)
    flask[1..].all? { |el| el === flask[0] }
  end

  def last_non_empty_index(flask)
    flask.rindex { |el| !el.zero? }
  end

  def first_empty_index(flask)
    flask.find_index { |el| el.zero? }
  end
end
