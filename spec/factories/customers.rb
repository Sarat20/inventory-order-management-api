FactoryBot.define do
  factory :customer do
    name { "John" }
    email { Faker::Internet.unique.email }

   
    trait :alice do
      name { "Alice" }
      email { "alice@test.com" }
    end


    trait :corporate do
      name { "Acme Corp" }
      email { "corp@acme.com" }
    end


    trait :indian do
      name { "Ravi" }
      email { "ravi@test.com" }
    end
  end
end
