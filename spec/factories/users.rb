FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { Faker::Internet.unique.email }
    password { "password123" }
    role { :staff }
    status { :active }
  end

  factory :admin, class: "User" do
    name { "Admin" }
    email { "admin@test.com" }
    password { "password123" }
    role { :admin }
    status { :active }
  end
end
