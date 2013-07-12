# encoding: utf-8
require 'test_helper'

require "#{Rails.root}/app/helpers/build_helper"

class BuilderTest < ActiveSupport::TestCase

  def test_build_genera_and_family
  	# 3 Families, 5 Genus
  	test_data = "<i>1</i>, 1<br>\n<i>2</i>, 1<br>\n<i>3</i>, 2<br>\n<i>4</i>, 2<br>\n<i>5</i>, 3<br>"

  	assert_difference("Family.count", 3) do
  		assert_difference("Genera.count", 5) do
  			BuildHelper::build_genera_and_family test_data
  		end
  	end
  end

  def test_build_build_species_scientific_names
  	# 2 Species
  	@genera = FactoryGirl.create(:genera, :name => "Chaetopelma", :family => FactoryGirl.create(:family))
  	# This test data is just pulled right from the source
  	test_data = "<ul>\n<li>species: <a href=\"./references.php?id=1876\"><em>Chaetopelma adenense</em></a> <a href=\"./bib.php?id=6331\">Simon, 1890</a>\n</li>\n<li>species: <a href=\"./references.php?id=1878\"><em>Chaetopelma arabicum</em></a> (<a href=\"./bib.php?id=6699\">Strand, 1908</a>)\n</li>"
  	assert_difference("Species.count", 2) do
  		BuildHelper::build_species_scientific_names @genera, test_data
  	end
  end

end
