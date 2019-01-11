# Create Users
User.create([
                { email: 'pittohio@trantorinc.com', password: 'trantorpwd', first_name: 'Pittohio', last_name: 'User' },
                { email: 'trantor@trantorinc.com', password: 'trantorpwd', first_name: 'Trantor', last_name: 'User' }
            ])

# Create Roles Master
Role::ALL.each { |role| Role.create(name: role) unless Role.find_by(name: role).present? }
