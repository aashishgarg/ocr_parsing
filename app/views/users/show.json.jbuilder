json.user do |json|
  json.partial! 'users/user', user: current_user, show_token: true
end