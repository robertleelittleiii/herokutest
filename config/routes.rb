Billabongnj::Application.routes.draw do
  
    mount Resque::Server, :at => "/resque"

 
  resources :importer_items do
 collection do
      get "create_empty_record"
    end
  end
  
  resources :importers do
     collection do
      get "create_empty_record"
    end
  end

  get "feed_management/importfile"

  get "feed_management/webservicesync"

  get "customer_actions/order_history"

  resources :order_items do
    collection do
      get "create_empty_record"
    end
  end

  resources :orders do
    collection do
      get "create_empty_record"
      get "create_order"
      get "enter_order"
      get "order_success"
      get "invoice_slip"
      get "user_orders"
    end
  end
  
  resources :product_details do
    collection do
      get "create_empty_record"
      get "duplicate_record"
    end
  end

  resources :suppliers do
    collection do
      get "create_empty_record"
   
    end
  end

  resources :products do
    collection do
      get "create_empty_record"
      get "product_table"
      get "show_detail"
      get "render_category_div"
      get "render_image_section"
      
    end
  end

  resources :registration do
    collection do
      get "login"
      get "forgot"
      post "forgot"
      get "reset"
      post "reset"
      get "password_is_reset"
      get "registration"
      get "lostwithemail"
      get "testinventory"
    end
  end

  resources :sliders do
    collection do
      get "create_empty_record"
      post "sort"
    end
  end

  get "mailer/simple_form"

  resources :pictures

  resources :menus do
    collection do
      get "create_empty_record"
      get "ajax_load_partial"
    end
  end

  resources :user_attributes

  resources :roles

  resources :rights

  resources :users

  #get "site/index.html"

  resources :pages do
    collection do
      get "create_empty_record"
      get "get_sliders_list"
    end
  end
  
  resources :site do
    collection do
      get "show_prop_slideshow"
      get "show_prop_slideshow_partial"
      get "show_products"
      get "product_detail"
      get "add_to_cart"
      get "show_cart"
      get "empty_cart"
      get "get_sizes_for_color"
      get "get_shopping_cart_info"
      get "check_out"
      get "increment_cart_item"
      get "decrement_cart_item"
      get "delete_cart_item"
      get "get_shopping_cart_item_info"
      get "get_cart_summary_body"
      get "get_cart_contents"
      
    end
  end

  resources :attachments do
    new do
      get "create"
    end
    collection do
      get "manage"
    end
    collection do
      get "delete"
    end
  end


  match  '/forgot',                            :controller => 'registration',     :action => 'forgot'
  match    '/lost',                            :controller => 'registration',     :action => 'lost'
  match '/reset/:reset_code',                  :controller => 'registration',     :action => 'reset'
  match '/activate/:activation_code',          :controller => 'registration',     :action => 'activate'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.

  match ':controller(/:action(/:id(.:format)))'

  root :to => "site#index"
end
