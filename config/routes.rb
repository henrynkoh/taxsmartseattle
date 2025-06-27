Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'dashboard#index'

  resources :tax_tips, only: [:index], controller: 'dashboard', action: 'tax_tips'
  resources :videos, only: [:index], controller: 'dashboard', action: 'videos'
  
  post '/videos/:id/approve', to: 'dashboard#approve_video', as: :approve_video
  post '/videos/:id/retry', to: 'dashboard#retry_video', as: :retry_video
  post '/force_crawl', to: 'dashboard#force_crawl', as: :force_crawl
  
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'
end
