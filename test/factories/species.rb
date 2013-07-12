FactoryGirl.define do
  factory :species do

    sequence :scientific_name do |n|
      "Arachnid #{n}"
    end

    sequence :common_name do |n|
      "Spider #{n}"
    end

    sequence :permalink do |n|
      "arachnid-#{n}"
    end

    sequence :description do |n|
      "Arachnid #{n} is a totally awesome spider."
    end

    sequence :characteristics do |n|
      "black, white-stripes"
    end

    sequence :image_url do |n|
      "http://spiderid.co/spider-#{n}.png"
    end

    venomous false

  end
end