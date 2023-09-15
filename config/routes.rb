Rails.application.routes.draw do
  scope '/api', defaults: { format: :json } do
    devise_for :users, defaults: { format: :json }, path_names: { sign_in: :login }, controllers: { sessions: :sessions, registrations: :registrations }

    resource :user, only: %i[show]
    resources :budgets, only: %i[index create show update destroy]
    resources :expenses, only: %i[index create show update destroy] do
      member do
        put 'pay_out', to: 'expenses#pay_out'
        put 'unpay_out', to: 'expenses#unpay_out'
      end
    end
  end
end
