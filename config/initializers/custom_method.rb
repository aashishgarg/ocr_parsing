class Array
  def separated
    inject { |x, y| x.to_s << y.to_s }.split(',')
  end
end