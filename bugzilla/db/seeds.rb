# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

USERS = [
  { name: 'Manager', type: 'Manager', email: 'manager12@gmail.com' },
  { name: 'QualityAssurance', type: 'QualityAssurance', email: 'qa12@gmail.com' },
  { name: 'Developer', type: 'Developer', email: 'dev12@gmail.com' }
].freeze

USERS.each do |u|
  User.new(**u, password: '123456').tap do |user|
    user.confirm
    user.save
  end
end
