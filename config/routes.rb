Spiderid::Application.routes.draw do
  # The API. Only JSON is allowed here.
  namespace :api, :constraints => {:format => 'json'} do
    namespace :v1 do
      get '/', to: 'default#index', as: :api_info
    end
  end

  root 'default#index'
end
