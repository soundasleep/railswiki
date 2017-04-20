Railswiki::Engine.routes.draw do
  # get "/auth/google_login/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", as: :logout

  resources :pages

  root to: "pages#index"
end
