FactoryGirl.define do
  factory :genera do

    sequence :name do |n|
      "Genera #{n}"
    end

  end
end