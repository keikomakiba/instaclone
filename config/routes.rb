Rails.application.routes.draw do
    root to: 'top#index'
    
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
    

    resources :blogs do 
      collection do 
      post:confirm
      get :top
    end
  end
  
    resources :sessions, only: [:new, :create, :destroy]
    resources :users
    resources :favorites, only: [:create, :destroy]
    
    get '*path', controller: 'application', action: 'render_404'

end
