Rails.application.routes.draw do
  root to: "main#index"

  resources :solicitudes, only: [:index, :create, :show] do
    resources :shippings, only: [:index] do
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :shippings, only: [:index]
      resources :solicitudes, only: [:create, :index]
      get '/status', to: 'solicitudes#status'
      get '/download_pdf', to: "solicitudes#download_pdf"
    end
  end
  
end