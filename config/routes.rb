Railswiki::Engine.routes.draw do
  # get "/auth/google_login/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", as: :logout

  get "/sessions/not_authorized"
  get "/sessions/no_invite"

  resources :pages do
    get :history
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :invites, only: [:index, :new, :create, :show, :destroy]
  resources :histories, only: [:show, :index, :destroy]
  resources :uploaded_files do
    collection do
      get :image_dialog
      get :file_dialog
    end
  end

  get "/download/:title", to: "uploaded_files#download", as: "download_file", format: false, constraints: { title: /.*/ }
  get "*path", to: 'pages#show', via: :get, as: :title

  root to: "pages#show", id: "Home"
end
