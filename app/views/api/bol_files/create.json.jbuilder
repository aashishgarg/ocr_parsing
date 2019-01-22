json.bol_file do |json|
  json.partial! 'bol_file', bol_file: @bol_file
end
json.merge!({ errors: @errors })  if @errors&.present?
