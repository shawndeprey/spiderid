require 'test_helper'

class GeneraTest < ActiveSupport::TestCase
  setup do
    @genera = FactoryGirl.create(:genera)
  end

  def test_genera_create
    assert_not_nil @genera.name
  end

  def test_relationships
    # First test that the relationship works at all
    @genera.family = FactoryGirl.create(:family)
    @genera.species << FactoryGirl.create(:species)
    assert_equal @genera.family, Family.last
    assert_equal @genera.species.first, Species.last
    # Next test we can add lists of objects
    @genera.species << FactoryGirl.create(:species)
    assert_equal @genera.species.last, Species.last
  end

end
