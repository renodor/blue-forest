# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quis officiis expedita cupiditate ipsa accusamus eius possimus porro vero perspiciatis ipsum nulla excepturi, non, rem numquam quasi similique facere et deleniti."


p 'Destroy all categories'
Category.destroy_all
p '----------> done'

p 'Destroy all products'
Product.destroy_all
p '----------> done'

p 'Create categories'
pets = Category.create!(name: 'pets', description: description)
toys = Category.create!(name: 'toys', description: description, parent_id: pets.id)
food = Category.create!(name: 'food', description: description, parent_id: pets.id)

health = Category.create!(name: 'health', description: description)
masks = Category.create!(name: 'masks', description: description, parent_id: health.id)
gloves = Category.create!(name: 'gloves', description: description, parent_id: health.id)
p "----------> done, #{Category.count} categories created"

categories = [toys, food, masks, gloves]

p 'Create products, product variations and product/categories associations'
10.times do |n|
  product = Product.create!(name: Faker::DcComics.hero, description: description, price: rand(50) + rand.round(2))
  ProductVariation.create!(product_id: product.id, color: Faker::Color.color_name, size: 'S' , quantity: rand(10))
  ProductVariation.create!(product_id: product.id, color: Faker::Color.color_name, size: 'M' , quantity: rand(10))
  ProductVariation.create!(product_id: product.id, color: Faker::Color.color_name, size: 'L' , quantity: rand(10))
  ProductVariation.create!(product_id: product.id, color: Faker::Color.color_name, size: 'XL' , quantity: rand(10))

  ProductCategory.create!(product_id: product.id, category_id: categories[rand(4)].id)
  p "product #{n + 1} created!"
end
p "----------> done, #{Product.count} products created"
p "----------> done, #{ProductVariation.count} product variations created"
p "----------> done, #{ProductCategory.count} products/categories created"


p 'Destroy all users'
User.destroy_all
p '----------> done'

p 'Create users'

10.times do |n|
  User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, phone: Faker::PhoneNumber.cell_phone, address: Faker::Address.street_address, password: '123456', password_confirmation: '123456', email: "user#{n + 1}@gmail.com")
  p "user #{n + 1} created!"
end

p "----------> done, #{User.count} products created"
