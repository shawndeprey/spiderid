class Api::V1::SpeciesController < Api::V1::BaseController

	# GET /api/v1/species/search.json
	def search
		@results = Species.search(params[:q], params[:page] || 1)
		#render json: @results, root: false, each_serializer: TireSpeciesSerializer
		render json: @results, each_serializer: TireSpeciesSerializer
	end

end