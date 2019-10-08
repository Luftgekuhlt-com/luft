Rails.application.routes.draw do

  namespace :admin do
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  get 'login' => 'sessions#new', as: :sdo_login
  post 'login' => 'sessions#create', as: :sdo_session
  get 'logout' => 'sessions#destroy', as: :sdo_logout

  get 'register' => 'accounts#new', as: :new_account
  post 'register' => 'accounts#create', as: :account_create
  get 'forgot' => 'accounts#forgot_password', as: :forgot_password
  post 'forgot' => 'accounts#send_forgot_password', as: :send_forgot_password
  get 'top-nav' => 'accounts#top_nav'

  namespace :admin do
    root "home#index"
    get 'content-areas' => "home#content", as: :content_areas
    get 'oauth2-redirect' => "oauth#oauth2_redirect", as: :oauth2_redirect

    resources :documents, path: "pages" do
      resources :document_sections, path: "sections" do
        member do
          get :move
        end
        resources :document_parts, path: "parts" do
          member do
            get :move
            get :bulk
            match :bulk_upload, via: [:get, :post, :patch]
          end
          resources :document_part_images do
            member do
              get :move
            end
            collection do
            end
          end
        end
      end
    end
    resources :production_pages, path: "productions" do
      resources :document_sections, path: "sections" do
        member do
          get :move
        end
        resources :document_parts, path: "parts" do
          member do
            get :move
            get :bulk
            match :bulk_upload, via: [:get, :post, :patch]
          end
          resources :document_part_images do
            member do
              get :move
            end
            collection do
            end
          end
        end
      end
    end
    match 'home-slides/preview' => 'home_slides#preview', as: :home_slide_preview, via: [:get, :post, :patch]
    match 'home-slides/preview-upload' => 'home_slides#preview_upload', as: :home_slide_preview_upload, via: [:get, :post]
    resources :home_slides do
      member do
        get :move
      end
      collection do
        post :add_slide_tag
      end
    end
    match 'home-portals/preview' => 'home_portals#preview', as: :home_portal_preview, via: [:get, :post, :patch]
    match 'home-portals/preview-upload' => 'home_portals#preview_upload', as: :home_portal_preview_upload, via: [:get, :post]
    resources :home_portals, path: 'home-portals' do
      member do
        get :move
      end
      collection do
        post :add_portal_tag
      end
    end
    resources :news_links
    resources :press_releases
    resources :performance_histories
  end

  resources :performances, path: 'tickets' do
    member do
      get 'best-avail' => 'performances#show', as: :best_avail
      get 'syos' => 'performances#syos', as: :syos
      get 'syos-screen/:screen' => 'performances#syos_screen', as: :syos_screen
      post 'purchase' => 'performances#purchase', as: :purchase
      post 'syos_reserve' => 'performances#syos_reserve', as: :syos_reserve

    end
  end

  get 'cart' => 'cart#show', as: :view_cart
  delete 'remove-item/:id' => 'cart#remove_item', as: :cart_remove_item
  delete 'remove-package/:id' => 'cart#remove_package', as: :cart_remove_package
  delete 'remove-flex-package/:id' => 'cart#remove_flex_package', as: :cart_remove_flex_package



  match '*.php', to: redirect('/404'), via: [:get, :post, :patch]

  get '*a', :to => 'documents#show'
end
