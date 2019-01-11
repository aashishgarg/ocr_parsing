# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puser = User.create(email: 'pittohio@trantorinc.com', password: 'trantorpwd', first_name: 'Pittohio', last_name: 'User', company: 'Pittohio')
User.create(email: 'trantor@trantorinc.com', password: 'trantorpwd', first_name: 'Trantor', last_name: 'User', company: 'Trantor, Inc.')

Role::ALL.each { |role| Role.create(name: role) unless Role.find_by(name: role).present? }
