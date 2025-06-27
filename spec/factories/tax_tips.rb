FactoryBot.define do
  factory :tax_tip do
    topic { "MyString" }
    industry { "MyString" }
    strategy { "MyText" }
    case_study { "MyText" }
    sentiment { 1.5 }
    source_url { "MyString" }
  end
end
