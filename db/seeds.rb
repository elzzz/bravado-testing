# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

CSV.foreach(Rails.root.join('db/data/users.csv'), headers: false) do |row|
  puts "User #{row[0]}"
  User.create(
    {
      id: row[0].to_i,
      name: row[1],
      company: row[2]
    }
  )
end

CSV.foreach(Rails.root.join('db/data/offers.csv'), headers: false) do |row|
  puts "Offer #{row[0]}"
  Offer.create(
    {
      id: row[0].to_i,
      price: row[1].to_f,
      company: row[2]
    }
  )
end

CSV.foreach(Rails.root.join('db/data/departments.csv'), headers: false) do |row|
  puts "Department #{row[0]}"
  Department.create(
    {
      id: row[0].to_i,
      name: row[1]
    }
  )
end

CSV.foreach(Rails.root.join('db/data/user_departments.csv'), headers: false) do |row|
  puts "User Departments #{row[0]}"
  UserDepartment.create(
    {
      id: row[0].to_i,
      user_id: row[1].to_i,
      department_id: row[2].to_i
    }
  )
end

CSV.foreach(Rails.root.join('db/data/offer_departments.csv'), headers: false) do |row|
  puts "Offer Departments #{row[0]}"
  OfferDepartment.create(
    {
      id: row[0].to_i,
      offer_id: row[1].to_i,
      department_id: row[2].to_i
    }
  )
end