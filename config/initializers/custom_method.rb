class Array
  def separated
    empty? ? self : inject { |x, y| x.to_s << y.to_s }.split(',')
  end
end