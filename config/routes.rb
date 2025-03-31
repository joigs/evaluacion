Rails.application.routes.draw do



  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"



  root 'home#index', as: 'home'

  post 'check_all_expirations', to: 'home#check_all_expirations', as: :check_all_expirations

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :authentication, path: '', as: '' do
    resources :users, path: '/users' do
      collection do
        get :new_client
        post :create_client
      end
      member do
        get :edit_client
        patch :update_client
        get :manage_permisos
        patch :update_permisos
      end
    end
    resources :sessions, only: [:new, :create, :destroy], path: '/login', path_names: { new: '/' }
  end




  resources :users, only: :show, path: '/user', param: :username, as: 'perfil' do
    member do
      patch :toggle_tabla
    end
  end





  resources :facturacions, only: [:new, :create, :index, :edit, :update, :show], path: 'cotizaciones' do

    member do
      get :download_solicitud_file
      get :download_cotizacion_doc_file
      get :download_cotizacion_pdf_file
      get :download_orden_compra_file
      get :download_facturacion_file
      get :download_all_files
      patch :upload_cotizacion
      patch :marcar_entregado
      patch :upload_orden_compra
      patch :update_fecha_inspeccion
      patch :upload_factura
      get :manage_files
      patch :replace_file
      get :download_solicitud_template
      get :download_cotizacion_template
    end
    collection do
      get :new_bulk_upload
      post :bulk_upload
      get :new_bulk_upload_pdf
      post :bulk_upload_pdf 
    end


    resources :observacions, only: [:create, :edit, :update, :destroy]
  end

  resources :permisos


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
