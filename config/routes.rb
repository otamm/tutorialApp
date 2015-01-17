Rails.application.routes.draw do
  # syntax for route naming: <HTTP method> '<name that will correspond to the page on URL>' => '<method of a pre-defined controller>'
  get 'sessions/new'

  root 'static_pages#home' #changes 'URL code' to 'Ruby code', "class_name#method" is the syntax for returning the home controller method for 'static_pages' controller.

  get 'help'                => 'static_pages#help'

  get 'about'               => 'static_pages#about'

  resources :users, except: :new

  get 'signup'            , to: 'users#new', as: :signup #only '_path' methods automatically created are these generated through 'resources'

  get 'login'               => 'sessions#new'    #instead of adding something like 'resources :sessions', well only add the specific HTTP methods
                                                 #needed to manage user's sessions.
  post 'login'              => 'sessions#create' #get 'login' : page for new sessions; post 'login' : send form info to server (successful login or not) ; delete 'logout' : destroys session, once website is accessed again, login form will need to be filled in order to access user's area.

  delete 'logout'           => 'sessions#destroy'
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
