json.(user, :id, :email, :first_name, :last_name, :company, :phone, :fax)
json.token user.generate_jwt