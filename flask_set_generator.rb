class FlaskSetGenerator
  EMPTY_FLASK_AMOUNT = 2
  FLASK_CAPACITY = 4
  FLASK_AMOUNT = 4

  def self.call(flask_amount = FLASK_AMOUNT)
    @flask_amount = flask_amount
    generate_flask_set
  end

private

  def self.generate_flask_set
    flask_set = []
    (1..@flask_amount).each do |color|
      flask_set << [color] * FLASK_CAPACITY
    end
    EMPTY_FLASK_AMOUNT.times do
      flask_set << [0] * FLASK_CAPACITY
    end
    flask_set
  end
end
