Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "static_pages#index"

  devise_for :users
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post   'sessions'      => 'sessions#create',      :as => 'login'
        delete 'sessions'      => 'sessions#destroy',     :as => 'logout'
        post   'registrations/email' => 'registrations#email',  :as => 'email'

        get 'locations/find_users'  => 'locations#find_users',  :as => 'find_users'
        get 'not_confirmed_users/confirm'  => 'not_confirmed_users#confirm',  :as => 'confirm'

        post 'users/set_fcm_token'  => 'users#set_fcm_token',   :as => 'set_fcm_token'
        post 'remote_devices/update_ip'  => 'remote_devices#update_ip',   :as => 'update_id'

        resources :locations,  only: [:create, :index]
        resources :remote_devices,  only: [:index]
        resources :vk, only: [:create]
        resources :user_profiles, only: [:create]
        resources :hair_colors, only: [:index]
        resources :not_confirmed_users
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
