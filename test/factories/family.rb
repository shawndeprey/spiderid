FactoryGirl.define do
  factory :family do

    sequence :name do |n|
      "Family #{n}"
    end

  end
end