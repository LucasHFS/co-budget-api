require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiqworkerqueue'

  scope '/api', defaults: { format: :json } do
    devise_for :users, defaults: { format: :json }, path_names: { sign_in: :login }, controllers: { sessions: :sessions, registrations: :registrations }

    resource :user, only: %i[show]
    resources :budgets, only: %i[index create show update destroy]
    resources :transactions, only: %i[index create show update destroy] do
      member do
        put 'pay', to: 'transactions#pay'
        put 'unpay', to: 'transactions#unpay'
      end
    end
  end
end
