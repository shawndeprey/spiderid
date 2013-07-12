require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  setup do
    @family = FactoryGirl.create(:family)
  end

  def test_family_create
    assert_not_nil @family.name
  end

  def test_relationships
    # First test that the relationship works at all
    @family.generas << FactoryGirl.create(:genera)
    @family.species << FactoryGirl.create(:species)
    assert_equal @family.generas.first, Genera.last
    assert_equal @family.species.first, Species.last
    # Next test we can add lists of objects
    @family.generas << FactoryGirl.create(:genera)
    @family.species << FactoryGirl.create(:species)
    assert_equal @family.generas.last, Genera.last
    assert_equal @family.species.last, Species.last
  end

end
