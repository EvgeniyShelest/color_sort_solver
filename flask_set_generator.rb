class FlaskSetGenerator
  EMPTY_FLASK_AMOUNT = 2
  FLASK_CAPACITY = 4
  FLASK_AMOUNT = 4

  def initialize(flask_amount = FLASK_AMOUNT, flask_capacity = FLASK_CAPACITY)
    @flask_amount = Integer(flask_amount)
    @flask_capacity = Integer(flask_capacity)
  end

  def call
    generate_flask_set
  end

private

  def generate_flask_set
    flask_set = []
    (1..@flask_amount).each do |color|
      flask_set << [color] * @flask_capacity
    end
    EMPTY_FLASK_AMOUNT.times do
      flask_set << [0] * @flask_capacity
    end
    flask_set
  end
end
