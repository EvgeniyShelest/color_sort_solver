module FlaskSetShuffle
  def shuffle(n = 1, silent: false)
    n.times do
      random_move
      unless silent
        inspect
        p '-'*@flask_set.size*3
      end
    end
    @potential_moves = nil
  end

private

  def random_move
    from_flask = random_non_empty_flask
    to_flask = random_non_full_flask(from_flask)
    to_flask[first_empty_index(to_flask)] = from_flask[last_non_empty_index(from_flask)]
    from_flask[last_non_empty_index(from_flask)] = 0
  end

  def random_non_empty_flask
    @flask_set.select {|flask| !empty?(flask) }.sample
  end

  def random_non_full_flask(except_flask)
    @flask_set.select {|flask| flask.include?(0) && flask != except_flask }.sample
  end
end
