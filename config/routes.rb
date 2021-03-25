Eivid::Engine.routes.draw do

  resources :videos do
    post 'upload_video', on: :collection
  end
  
end
