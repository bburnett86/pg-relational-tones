Rails.application.routes.draw do

  root to: 'session#home'

  resources :users

  resources :sessions

  get '/import', to: "session#import"

  post '/import', to: 'users#import'

  get '/login', to: 'session#login'

  post '/login', to: 'session#authenticate'

  get '/logout', to: 'session#logout'

  get '/auth/:provider/callback', to: 'session#connect'

  get '/playlists/partial', to: 'playlists#partial'

  post '/playlists/temp', to: 'playlists#temp'

  resources :playlists, only: [:index, :show, :create]

  get '/playlists/:id/partial', to: 'playlists#tracks'

  get '/playlists/:id/carousel', to: 'playlists#carousel'

  get '/playlists/player/:id', to: 'playlists#player'

  get '/playlists/track/:id', to: 'playlists#track'

end
