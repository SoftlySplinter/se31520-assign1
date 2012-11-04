require_relative 'models/user.rb'
require_relative 'models/broadcast.rb'

site = 'http://localhost:3000'
user = 'admin'
password = 'taliesin'

User.site = site
User.user = user
User.password = password

Broadcast.site = site
Broadcast.user = user
Broadcast.password = password

broadcast = Broadcast.find(1)
user = User.find(broadcast.user_id)

puts user.firstname
