class Array
  def separated
    empty? ? self : inject { |x, y| x.to_s << y.to_s }.split(',')
  end
end

class Symbol
  def apply_transform_rule!
    to_s.apply_transform_rule!
  end
end

class String
  def apply_transform_rule!
    to_s.delete(' ').camelcase
  end
end

class Hash
  def mappable_transform!
    transform_keys!(&:apply_transform_rule!)
  end

  def details_hash
    details = delete('Details') || delete('details') || delete(:details) || delete(:Details)
    details.present? ? { 'Details' => details.first } : {}
  end

  def mappable!
    mappable_transform!.merge!(details_hash.mappable_transform!)
  end

  def provision_details_hash!
    self['Details'] = [{}]
    details = Attachment::MERGING_HASH.dup.delete(:Details)&.first || {}
    return self if details.blank?

    details.keys.each { |key| self['Details'].first.merge!(key.to_s => delete(key.to_s)) }
    self
  end
end