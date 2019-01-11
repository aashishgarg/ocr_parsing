show_token = true if local_assigns[:show_token].nil?

json.(user, :id, :email, :first_name, :last_name, :phone, :fax, :roles)
json.token user.generate_jwt if show_token