module ApplicationHelper
	# Bootstrap Guide Resource: http://railsapps.github.io/twitter-bootstrap-rails.html

	# Simple Form for Twitter Bootstrap
	# Inside your views, use the 'simple_form_for' with one of the Bootstrap form
  # classes, '.form-horizontal', '.form-inline', '.form-search' or
  # '.form-vertical', as the following:
  #
  #   = simple_form_for(@user, html: {class: 'form-horizontal' }) do |form|

	# External Resources
	# American Museum of Natural History
	GENERA_AND_FAMILY		= "http://research.amnh.org/iz/spiders/catalog/GENERIC.IND.html"
	SPECIES							= "http://research.amnh.org/oonopidae/catalog/names.php"

	# Insect Identification
	INSECT_ID						= "http://www.insectidentification.org"
	NORTH_AMERICAN			= "#{ApplicationHelper::INSECT_ID}/insect-search-results.asp?display=form&search3=Arachnida&Submit=SEARCH&search4="

	# Araneae
	ARANEAE							= "http://www.araneae.unibe.ch/"
	ARANEAE_DATA				= "#{ApplicationHelper::ARANEAE}/data"
	ANAREAE_BUILD_OUTER = 5000

	def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

end
