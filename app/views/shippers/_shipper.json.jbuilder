json.(shipper, :id, :name, :address1, :address2, :city, :state, :zip)

json.user do |user|
  user.partial! 'users/user', user: shipper.user
end