# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'Password123!' }
    password_confirmation { 'Password123!' }
    role { :user }
    
    trait :admin do
      role { :admin }
    end
    
    trait :super_admin do
      role { :super_admin }
    end
    
    factory :admin_user, traits: [:admin]
    factory :super_admin_user, traits: [:super_admin]
  end
end