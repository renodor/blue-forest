# This file should contain all the record creation needed
# to seed the database with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).

require 'faker'
require 'open-uri'

short_description = 'Lorem ipsum dolor sit amet'
# rubocop:disable Metrics/LineLength
long_description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Incidunt labore distinctio voluptatem totam, veniam sunt officiis quidem ex maxime enim deleniti ullam ut officia temporibus ducimus assumenda nemo ab quibusdam!'
# rubocop:enable Metrics/LineLength

p 'Destroy all categories'
Category.destroy_all
p '----------> done'

p 'Destroy all products'
Product.destroy_all
p '----------> done'

p 'Create categories'
pets = Category.create!(name: 'pets', description: long_description)
toys = Category.create!(name: 'toys', description: long_description, parent_id: pets.id)
food = Category.create!(name: 'food', description: long_description, parent_id: pets.id)

health = Category.create!(name: 'health', description: long_description)
masks = Category.create!(name: 'masks', description: long_description, parent_id: health.id)
gloves = Category.create!(name: 'gloves', description: long_description, parent_id: health.id)
p "----------> done, #{Category.count} categories created"

categories = [toys, food, masks, gloves]

p 'Create products, product variations and product/categories associations'
# rubocop:disable Metrics/BlockLength
10.times do |n|
  product = Product.new(
    name: "Product#{n + 1}",
    short_description: short_description,
    long_description: long_description
  )

  product.save!

  product_photo = ProductPhoto.new(color: 'red', main: true)
  product_photo.product = product
  product_photo.photos.attach(
    [
      { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846867/744-500x500_q9y6wr.jpg'),
        filename: '1.png', content_type: 'image/jpg' },
      { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/861-500x500_s0fflw.jpg'),
        filename: '2.png', content_type: 'image/jpg' }
    ]
  )
  product_photo.save!

  product_photo = ProductPhoto.new(color: 'blue')
  product_photo.product = product
  product_photo.photos.attach(
    [
      { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/730-500x500_p309fr.jpg'),
        filename: '3.png', content_type: 'image/jpg' },
      { io: URI.open('https://res.cloudinary.com/blueforest/image/upload/v1588846864/823-500x500_ock3ba.jpg'),
        filename: '4.png', content_type: 'image/jpg' }
    ]
  )
  product_photo.save!

  ProductVariation.create!(product_id: product.id, color: 'red', size: 'S',
                           quantity: 10, price: rand(50) + rand.round(2))

  ProductVariation.create!(product_id: product.id, color: 'red', size: 'M',
                           quantity: 10, price: rand(50) + rand.round(2))

  ProductVariation.create!(product_id: product.id, color: 'blue', size: 'S',
                           quantity: 10, price: rand(50) + rand.round(2))

  ProductVariation.create!(product_id: product.id, color: 'blue', size: 'M',
                           quantity: 10, price: rand(50) + rand.round(2))

  ProductCategory.create!(product_id: product.id, category_id: categories[rand(4)].id)
  p "product #{n + 1} created!"
end
# rubocop:enable Metrics/BlockLength

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
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.cell_phone,
    password: '123456',
    password_confirmation: '123456',
    email: "user#{n + 1}@gmail.com",
    confirmed_at: DateTime.now
  )
  p "user #{n + 1} created!"
end

User.first.update(admin: true)

p "----------> done, #{User.count} users created"
