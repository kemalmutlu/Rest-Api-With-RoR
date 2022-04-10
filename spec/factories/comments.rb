FactoryBot.define do
  factory :comment do
    content { "MyText" }
    association :article
    association :user
  end
end
