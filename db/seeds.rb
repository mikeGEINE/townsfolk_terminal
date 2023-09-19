# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

categories = Category.create([{name: 'Basic'}, {name: 'Standart'}])

rooms = Room.create([{category: categories.first, door: '1', code: '1234', status: :ready},
                     {category: categories.second, door: '2', code: '9876', status: :housekeeping}])

user = User.create({email: 'admin@test.ru', password: '123456', password_confirmation: '123456'})
user.admin!
