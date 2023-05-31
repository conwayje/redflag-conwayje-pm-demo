Rails.application.routes.draw do
  devise_for :employees, controllers: { registrations: "employees/registrations" }
  devise_for :project_managers

  resources :tasks
  resources :project_managers
  resources :employees
  resources :projects

  get 'home/index'

  root "home#index"
end
