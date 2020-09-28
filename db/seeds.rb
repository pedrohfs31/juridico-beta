# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'faker'

# METHODS
def rand_id(model_class)
  rand( model_class.first.id..model_class.last.id )
end

puts "Cleaning the DB"
User.destroy_all
Availability.destroy_all
Meeting.destroy_all

times = {}
puts "Creating time schedules ..."
(8..17).to_a.each do |hour|
  (1..3).to_a.each do |period|
    case period
    when 1
      times["#{hour}.#{period}".to_f] = "#{sprintf("%02d", hour)}:00"
    when 2
      times["#{hour}.#{period}".to_f] = "#{sprintf("%02d", hour)}:20"
    else
      times["#{hour}.#{period}".to_f] = "#{sprintf("%02d", hour)}:40"
    end
  end
end

puts "Creating Users ..."
10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create!(
    email: "#{first_name}@#{last_name}.com",
    name: "#{first_name} #{last_name}",
    password: "123456",
    company: ["Ministério da Eco", "AGU", "UNB"].sample
  )
end

puts "Creating availabilities ...."
100.times do
  Availability.create!(
    date: rand(1..7).day.from_now,
    time: times.sample,
    # time: Time.at(rand * Time.now.to_i),
    user_id: rand_id(User),
    scheduled: false
  )
end

puts "Creating Meetings"
100.times do
  user_id = rand_id(User)
  availability_id = rand_id(Availability)
  Meeting.create!(
    user_id: user_id,
    availability_id: availability_id,
    subject: 'impeachment'
  )
end