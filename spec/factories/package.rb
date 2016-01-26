FactoryGirl.define do
  factory :package do
    sequence(:name) {|i| "R-lang Package #{i}" }
  end
end
