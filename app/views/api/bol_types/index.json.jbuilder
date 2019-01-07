json.bol_types do |json|
  json.array!(@bol_types) do |bol_type|
    json.partial! 'bol_type', bol_type: bol_type
  end
end


