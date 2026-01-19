Rails.application.routes.draw do
  root 'welcome#index'
  post 'clicks/increment', to: 'clicks#increment'
  get 'clicks/total', to: 'clicks#total'
  
  # Rutas para páginas de error
  get 'error/:code', to: 'welcome#error_page', as: 'error_page'
  get 'random_error', to: 'welcome#random_error'
end