Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # config/routes.rb
  root to: 'exchange#index'
  post '/calculate' => 'exchange#calculate'
  get '/prices' => 'exchange#prices'

end
