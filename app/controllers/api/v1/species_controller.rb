class Api::V1::SpeciesController < Api::V1::BaseController

	# GET /api/v1/species/search.json
	def search
		@results = Species.search_by(params[:q], params[:page] || 1)
		render json: @results, each_serializer: SpeciesSearchSerializer
	end

end