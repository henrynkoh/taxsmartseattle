FactoryBot.define do
  factory :video do
    title { "MyString" }
    script { "MyText" }
    video_path { "MyString" }
    thumbnail_path { "MyString" }
    youtube_id { "MyString" }
    status { "MyString" }
    tax_tip { nil }
  end
end
