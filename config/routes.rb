require 'sidekiq/web'

Spiderid::Application.routes.draw do
  # The API. Only JSON is allowed here.
  namespace :api, :constraints => {:format => 'json'} do
    namespace :v1 do
      get '/', to: 'default#index', as: :api_info
      get '/species/search', to: 'species#search'
    end
  end
  # admin_constraint = lambda { |request| request.env["rack.session"]["user_id"] && User.find(request.env["rack.session"]["user_id"]).admin? }
  # constraints admin_constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
  # end
  root 'default#index'
end
