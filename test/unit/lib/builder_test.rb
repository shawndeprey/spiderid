# encoding: utf-8
require 'test_helper'

require "#{Rails.root}/app/helpers/build_helper"

class BuilderTest < ActiveSupport::TestCase

  def test_build_genera_and_family
  	# 3 Families, 5 species
  	test_data = "<i>1</i>, 1<br>\n<i>2</i>, 1<br>\n<i>3</i>, 2<br>\n<i>4</i>, 2<br>\n<i>5</i>, 3<br>"

  	assert_difference("Family.count", 3) do
  		assert_difference("Genera.count", 5) do
  			BuildHelper::build_genera_and_family test_data
  		end
  	end
  end

end
