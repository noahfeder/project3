FactoryGirl.define do
  factory :todo do
    user nil
    item "MyString"
    completed false
  end
end
