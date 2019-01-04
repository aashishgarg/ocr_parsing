json.shippers do |json|
  json.array!(@shippers) do |shipper|
    json.partial! 'shipper', shipper: shipper, show_token: false
  end
end


