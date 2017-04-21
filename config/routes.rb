Railswiki::Engine.routes.draw do
  # get "/auth/google_login/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", as: :logout

  resources :pages do
    get :history
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :histories, only: [:show, :index, :destroy]
  resources :uploaded_files do
    collection do
      get :image_dialog
    end
  end

  match '*path', to: 'pages#show', via: :get, as: :title

  root to: "pages#show", id: "Home"
end
