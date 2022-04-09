FactoryBot.define do
  factory :access_token do
    token { "MyString" }
    user
  end
end
