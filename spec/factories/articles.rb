FactoryBot.define do
  factory :article do
    title { "Sample Article" }
    content { "Sample Content" }
    sequence(:slug) { |n| "sample-article-#{n}" }
  end
end
