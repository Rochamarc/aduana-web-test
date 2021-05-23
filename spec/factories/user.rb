FactoryBot.define do 
    factory :user do
        id { 20 }
        email { "email@email.com" } 
        password { "123456" }
        password_confirmation { "123456" }
    end
end
