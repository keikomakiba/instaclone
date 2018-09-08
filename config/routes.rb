Rails.application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
    root to: 'top#index'

    resources :blogs do 
      collection do 
      post:confirm
      get :top
    end
  end
  
    resources :sessions, only: [:new, :create, :destroy]
    resources :users
    resources :favorites, only: [:create, :destroy]
end
