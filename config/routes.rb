# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  # Public routes
  root to: 'home#index'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'
  get 'products', to: 'pages#products'
  get 'solutions', to: 'pages#solutions'
  get 'resources', to: 'pages#resources'
  get 'help', to: 'pages#help'
  
  # Authenticated routes
  get 'dashboard', to: 'dashboard#index'
  get 'profile', to: 'profiles#show'
  get 'analytics', to: 'analytics#index'
  get 'reports', to: 'reports#index'
  
  # Admin routes
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :edit, :update, :destroy]
    get 'settings', to: 'settings#index'
    get 'audit_logs', to: 'audit_logs#index'
    get 'health', to: 'health#index'
  end
  
  # Super admin routes
  namespace :super_admin do
    get 'dashboard', to: 'dashboard#index'
    get 'settings', to: 'settings#index'
  end
  
  # API routes for notifications
  resources :notifications, only: [:index] do
    collection do
      post 'mark_as_read'
    end
  end
end