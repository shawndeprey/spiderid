require 'test_helper'

class SpeciesTest < ActiveSupport::TestCase
  setup do
    @species = FactoryGirl.create(:species)
  end

  def test_species_create
    assert_not_nil @species.scientific_name
    assert_not_nil @species.common_name
    assert_not_nil @species.permalink
    assert_not_nil @species.description
    assert_not_nil @species.venomous
    assert_not_nil @species.characteristics
    assert_not_nil @species.image_url
  end

  def test_relationships
    # First test that the relationship works at all
    @species.family = FactoryGirl.create(:family)
    @species.genera = FactoryGirl.create(:genera)
    assert_equal @species.family, Family.last
    assert_equal @species.genera, Genera.last
  end

end
