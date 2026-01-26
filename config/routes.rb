# config/routes.rb
Rails.application.routes.draw do
  root "welcome#index"
  get "dashboard", to: "welcome#dashboard"
  get "error_page", to: "welcome#error_page"
  get "personal_data", to: "welcome#personal_data"
  post "save_personal_data", to: "welcome#save_personal_data"
  get "system_info", to: "welcome#system_info"
  get "advanced_dashboard", to: "welcome#advanced_dashboard"  # Nueva ruta

  resources :clicks, only: [ :index ] do
    collection do
      post "increment"
      get "total"
    end
  end

  get "random_error", to: "welcome#random_error"
end
