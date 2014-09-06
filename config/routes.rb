Rails.application.routes.draw do

  root 'public#index'

  get 'login', :to => 'users#login_form'
  post 'login', :to => 'users#login'
  #get 'register', :to => 'users#register_form'
  get 'logout', :to => 'users#logout'
  get 'users/edit_form', :to => 'users#edit_form'
  get 'users/control_panel', :to => 'users#control_panel'
  get 'users/email_confirmation_again', :to => 'users#email_confirmation_again'
  get 'users/resend_email', :to => 'users#resend_email'
  get 'users/welcome', :to => 'users#welcome'
  get 'users/forgot_password_form', :to => 'users#forgot_password_form'
  post 'users/reset_password', :to => 'users#reset_password'
  get 'users/reset_password_confirmation', :to => 'users#reset_password_confirmation'

  resources :users do
    member do
      get :email_confirmation

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
