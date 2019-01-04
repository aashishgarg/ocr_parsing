json.shippers do |json|
  json.array!(@shippers) do |shipper|
    json.partial! 'shipper', shipper: shipper
  end
end


