Rails.application.routes.draw do
  # ===== HEALTHCHECK PARA RAILWAY =====
  get "/up", to: proc { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
  get "healthcheck" => "rails/health#show"

  # ===== TU RUTA RAÍZ ORIGINAL =====
  root "welcome#index"

  # ===== RUTAS DE WELCOME CONTROLLER =====
  get "dashboard", to: "welcome#dashboard"
  get "error_page", to: "welcome#error_page"
  get "personal_data", to: "welcome#personal_data"
  post "save_personal_data", to: "welcome#save_personal_data"
  get "system_info", to: "welcome#system_info"
  get "random_error", to: "welcome#random_error"
  get "advanced_dashboard", to: "welcome#advanced_dashboard"

  # ===== RUTAS PARA EL CARRUSEL DE IMÁGENES =====
  get "carousel", to: "welcome#carousel"
  post "create_slide", to: "welcome#create_slide"
  delete "destroy_slide/:id", to: "welcome#destroy_slide", as: "destroy_slide"

  # ===== RUTAS PARA CUESTIONARIOS =====
  get "questionnaire", to: "welcome#questionnaire_form"
  post "submit_questionnaire", to: "welcome#submit_questionnaire"
  get "questionnaire_data", to: "welcome#questionnaire_data"
  get "questionnaire_list", to: "welcome#questionnaire_list"

  # ===== RUTAS PARA PRODUCTOS - AHORA USAN PRODUCTS CONTROLLER =====
  resources :products, only: [:index, :create, :update, :destroy] do
    collection do
      get :search
      get :data, to: 'products#index_json'
    end
  end
  
  # Ruta de compatibilidad para product_data (opcional)
  get "product_data", to: "products#index_json"
end