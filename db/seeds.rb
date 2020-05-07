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

images = [
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/730-500x500_p309fr.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/823-500x500_ock3ba.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846863/627-500x500_vb3ohc.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846863/530-500x500_p2pps6.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846862/519-500x500_zigrse.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846862/527-500x500_hcdyun.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846862/541-500x500_kl6oy4.jpg'),
  URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846862/413-500x500_knqcya.jpg')
]

p 'Create products, product variations and product/categories associations'
10.times do |n|
  product = Product.new(name: "Product#{n+1}", description: description)
  product.main_photo.attach(io: images[n], filename: "#{product.name}_main_photo.png", content_type: "image/jpg")
  product.save!

  ProductVariation.new(product_id: product.id, color: Faker::Color.color_name, size: 'S' , quantity: rand(10), price: rand(50) + rand.round(2))
  ProductVariation.create!(product_id: product.id, color: Faker::Color.color_name, size: 'M' , quantity: rand(10), price: rand(50) + rand.round(2))
  ProductVariation.create!(product_id: product.id, color: Faker::Color.color_name, size: 'L' , quantity: rand(10), price: rand(50) + rand.round(2))
  ProductVariation.create!(product_id: product.id, color: Faker::Color.color_name, size: 'XL' , quantity: rand(10), price: rand(50) + rand.round(2))

  ProductCategory.create!(product_id: product.id, category_id: categories[rand(4)].id)
  p "product #{n + 1} created!"
end
p "----------> done, #{Product.count} products created"
p "----------> done, #{ProductVariation.count} product variations created"
p "----------> done, #{ProductCategory.count} products/categories created"


p 'Destroy all orders'
Order.destroy_all
p '----------> done'

p 'Destroy all carts'
Cart.destroy_all
p '----------> done'

p 'Destroy all users'
User.destroy_all
p '----------> done'

p 'Create users'

10.times do |n|
  User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, phone: Faker::PhoneNumber.cell_phone, address: Faker::Address.street_address, password: '123456', password_confirmation: '123456', email: "user#{n + 1}@gmail.com")
  p "user #{n + 1} created!"
end

p "----------> done, #{User.count} users created"
