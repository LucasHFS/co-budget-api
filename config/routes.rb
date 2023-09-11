Rails.application.routes.draw do
  scope '/api', defaults: { format: :json } do
    devise_for :users, defaults: { format: :json }, path_names: { sign_in: :login }, controllers: { sessions: :sessions, registrations: :registrations }

    resource :user, only: %i[show]
    resources :clients, only: %i[index create update show destroy]
    resources :drivers, only: %i[index create update show destroy]

    resources :products, only: %i[index create show update destroy]
    resources :sale_events, only: %i[index create show update destroy]

    resources :orders, only: %i[index create show update destroy] do
      collection do
        get '/by_state', to: 'orders#by_state'

        put '/register', to: 'orders#register'
        put '/prepare', to: 'orders#prepare'
        put '/send', to: 'orders#send_order'
        put '/complete', to: 'orders#complete'
        put '/cancel', to: 'orders#cancel'
      end
    end

    resources :deliveries, only: %i[index create show update destroy] do
      collection do
        put '/register', to: 'deliveries#register'
        put '/start', to: 'deliveries#start'
        put '/complete', to: 'deliveries#complete'
        put '/cancel', to: 'deliveries#cancel'
      end
    end
  end
end
