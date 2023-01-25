class FlaskSet
  EMPTY_FLASK_AMOUNT = 2
  FLASK_CAPACITY = 4
  # COLORS == flask_amount
  def initialize(flask_amount = 4)
    @flask_amount = flask_amount
    generate_flask_set
  end

  class Node
    attributes :parent, :snapshot
    def initialize(parent = nil,)
    end
  end

  def shuffle(n = 1)
    n.times do
      random_move
      inspect
      p '-'*80
    end
  end

  def print
    @flask_set
  end

  def snapshot
    @flask_set.flatten.join
  end

  def inspect
    @flask_set.transpose.reverse.each do |row|
      p "%2d "*common_flask_amount % row
    end;nil
  end

  def solved?
    @flask_set.all? {|flask| flask[1..].all? {|el| el === flask[0]} }
  end

private

  def random_move
    from_flask = random_non_empty_flask
    to_flask = random_non_full_flask(from_flask)
    to_flask[first_empty_index(to_flask)] = from_flask[last_non_empty_index(from_flask)]
    from_flask[last_non_empty_index(from_flask)] = 0
  end

  def last_non_empty_index(flask)
    flask.rindex { |el| !el.zero? }
  end

  def first_empty_index(flask)
    flask.find_index { |el| el.zero? }
  end

  def random_non_empty_flask
    loop do
      random_flask_index = rand(common_flask_amount)
      return @flask_set[random_flask_index] if @flask_set[random_flask_index].any?
    end
  end

  def random_non_full_flask(except_flask)
    loop do
      random_flask_index = rand(common_flask_amount)
      next if except_flask === @flask_set[random_flask_index]
      flask = @flask_set[random_flask_index]
      return flask if flask.count { |i| i.zero? } > 0
    end
  end

  def common_flask_amount
    @flask_amount + EMPTY_FLASK_AMOUNT
  end

  def generate_flask_set
    @flask_set = []
    (1..@flask_amount).each do |color|
      @flask_set << [color] * FLASK_CAPACITY
    end
    EMPTY_FLASK_AMOUNT.times do
      @flask_set << [0] * FLASK_CAPACITY
    end
  end
end
