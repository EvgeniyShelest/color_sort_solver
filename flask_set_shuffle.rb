module FlaskSetShuffle
  def shuffle(n = 1)
    n.times do
      random_move
      inspect
      p '-'*@flask_set.size*3
    end
  end

private

  def random_move
    from_flask = random_non_empty_flask
    to_flask = random_non_full_flask(from_flask)
    to_flask[first_empty_index(to_flask)] = from_flask[last_non_empty_index(from_flask)]
    from_flask[last_non_empty_index(from_flask)] = 0
  end

  def random_non_empty_flask
    loop do
      random_flask_index = rand(@flask_set.size)
      return @flask_set[random_flask_index] if @flask_set[random_flask_index].any?
    end
  end

  def random_non_full_flask(except_flask)
    loop do
      random_flask_index = rand(@flask_set.size)
      next if except_flask === @flask_set[random_flask_index]
      flask = @flask_set[random_flask_index]
      return flask if flask.count { |i| i.zero? } > 0
    end
  end
end
