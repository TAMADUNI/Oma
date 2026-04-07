# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { 'Password123!' }
    password_confirmation { 'Password123!' }
    terms_of_service { true }
    active { true }
    role { :user }
    
    trait :admin do
      role { :admin }
    end
    
    trait :super_admin do
      role { :super_admin }
    end
    
    trait :inactive do
      active { false }
    end
    
    trait :without_terms do
      terms_of_service { false }
    end
    
    factory :admin_user, traits: [:admin]
    factory :super_admin_user, traits: [:super_admin]
  end
end