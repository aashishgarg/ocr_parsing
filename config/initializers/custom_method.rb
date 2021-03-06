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

  def apply_transform_rule
    to_s.gsub(' ', '').camelcase
  end

  def file_name
    split('.').first
  end

  def extension
    all_extensions = Rack::Mime::MIME_TYPES.keys
    array = split('.')
    array.shift
    array.select { |item| item.prepend('.').in?(all_extensions) }.first&.delete('.')
  end

  def serial_no
    array = split('.')
    array.shift
    array.select { |item| item.to_i.positive? }.first.to_i
  end
end

class Hash
  def mappable_transform!
    transform_keys!(&:apply_transform_rule!)
  end

  def mappable_transform
    transform_keys(&:apply_transform_rule)
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

    all_nil = true
    details.keys.each do |key|
      all_nil = false if key? key.to_s
      self['Details'].first.merge!(key.to_s => delete(key.to_s))
    end

    merge!('Details' => []) if all_nil
    self
  end
end