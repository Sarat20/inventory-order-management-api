Rails.logger.debug "Seeding database..."


admin = User.find_or_create_by!(email: "admin@inventory.com") do |u|
  u.name = "Admin User"
  u.password = "admin123"
  u.role = :admin
  u.status = :active
end


electronics = Category.find_or_create_by!(name: "Electronics")
groceries   = Category.find_or_create_by!(name: "Groceries")


supplier1 = Supplier.find_or_create_by!(email: "abc@supplier.com") do |s|
  s.name = "ABC Supplier"
end

supplier2 = Supplier.find_or_create_by!(email: "xyz@supplier.com") do |s|
  s.name = "XYZ Supplier"
end


Product.find_or_create_by!(name: "iPhone") do |p|
  p.price = 70000
  p.quantity = 10
  p.category = electronics
  p.supplier = supplier1
end

Product.find_or_create_by!(name: "Rice Bag") do |p|
  p.price = 1200
  p.quantity = 50
  p.category = groceries
  p.supplier = supplier2
end


Customer.find_or_create_by!(email: "john@test.com") do |c|
  c.name = "John Doe"
end

Customer.find_or_create_by!(email: "alice@test.com") do |c|
  c.name = "Alice"
end

Rails.logger.debug "Seeding completed!"
