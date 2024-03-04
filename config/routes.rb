Rails.application.routes.draw do
  root 'application#home'
  post 'games/move', to: 'games#move'
  get 'games', to: 'games#index'
  post 'games', to: 'games#create'
  delete 'games', to: 'games#delete'
end
