Rails.application.routes.draw do
  # ===== HEALTHCHECK PARA RAILWAY =====
  # Estas rutas son las que usa Railway para verificar que la app está viva
  get "up" => "rails/health#show", as: :rails_health_check
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

  # ===== RUTAS PARA PRODUCTOS =====
  get "products", to: "welcome#products"
  post "products", to: "welcome#create_product"
  patch "products/:id", to: "welcome#update_product"
  delete "products/:id", to: "welcome#destroy_product"
  get "products/search", to: "welcome#search_products"
  get "product_data", to: "welcome#product_data"
end
