class Array
  def separated
    empty? ? self : inject { |x, y| x.to_s << y.to_s }.split(',')
  end
end

class String
  def apply_transform_rule!
    delete(' ').camelcase
  end
end

class Hash
  def mappable!
    details = delete('Details') || delete('details') || delete(:details) || delete(:Details)
    transform_keys!(&:apply_transform_rule!)
    details.transform_keys!(&:apply_transform_rule!) if details.present? && details.is_a?(Hash)
    merge!('Details' => details) if details.present?
    self
  end
end