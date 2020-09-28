# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'faker'

User.destroy_all
Availability.destroy_all
# times = ["08:00", "08:20", "08:40", "09:00", "09:20", "09:40", "10:00", "10:20", "10:40", "11:00", "11:20", "11:40", "12:00", "12:20", "12:40"]
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
  User.create(
    email: Faker::Internet.email,
    password: "123456",
    company: ["Ministério da Eco", "AGU", "UNB"].sample
  )
end

puts "Creating availabilities ...."
100.times do
  Availability.create(
    date: Date.today+rand(30),
    time: times.sample,
    # time: Time.at(rand * Time.now.to_i),
    user_id: rand(1..10),
    scheduled: false
  )
end
