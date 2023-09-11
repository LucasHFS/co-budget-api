# def create_users
#   10.times do
#     User.create(
#       name: Faker::Name.name,
#       address: Faker::Address.full_address,
#       phone: Faker::PhoneNumber.phone_number,
#       reference_point: Faker::Address.community,
#       district: Faker::Address.community,
#       role: 'client'
#     )
#   end
# end

# def create_products
#   20.times do
#     Product.create(
#       name: Faker::Food.dish,
#       price_in_cents: Faker::Number.between(from: 100, to: 1000)
#     )
#   end
# end

# def create_sale_events
#   5.times do
#     SaleEvent.create(
#       name: Faker::Lorem.words.join(' '),
#       date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
#     )
#   end
# end

# def create_orders
#   50.times do
#     Order.create(
#       client: User.all.sample,
#       is_delivery: [true, false].sample,
#       notes: Faker::Lorem.paragraph,
#       sale_event: SaleEvent.all.sample,
#       state: %i[pending prepared sent completed canceled].sample
#     )
#   end
# end

# def create_line_items
#   50.times do
#     LineItem.create(
#       order: Order.all.sample,
#       product: Product.all.sample,
#       quantity: Faker::Number.between(from: 1, to: 5)
#     )
#   end
# end

# create_users
# create_products
# create_sale_events
# create_orders
# create_line_items
