
User.create!(
  name: "Admin User",
  email: "admin@inventory.com",
  role: :admin,
  status: :active
)

Category.create!(name: "Electronics")

Supplier.create!(
  name: "ABC Supplier",
  email: "supplier@test.com"
)

Customer.create!(
  name: "John Doe",
  email: "john@test.com"
)
