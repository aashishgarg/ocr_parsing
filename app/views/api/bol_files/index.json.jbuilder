json.bol_files do |json|
  json.array!(@bol_files) do |bol_file|
    json.partial! 'bol_file', bol_file: bol_file
  end
end
json.merge!({ errors: @errors })  if @errors&.present?



