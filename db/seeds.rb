# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# to reset the db and add new changes specified here, use 'bundle exec rake db:migrate:reset'
# use 'rake db:seed:<environment>' to populate a specific db, like 'rake db:seed:test'
User.create!(name: "Dummy Dude", email: "useless@gmail.com", password: "h4ck3d", password_confirmation: "h4ck3d",activated: true, activated_at: Time.zone.now)
User.find(1).update_attributes(role: 1)

99.times do |n|
  name = Faker::Name.name # uses the '.name' method of the 'Name' class of the 'Faker' gem.
  email = "useless-#{n+1}@bol.net" # increments n by 1 each iteration to create different e-mails
  password = "h4ck3d_n00b"
  User.create!(name: name, email: email, password: password, password_confirmation: password, activated: true, activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6) # take the first 6 users from the DB.

50.times do # creates dummy content for these 6 users' microposts.
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
