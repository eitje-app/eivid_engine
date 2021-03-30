Eivid::Engine.routes.draw do

  resources :videos do
    post 'upload_video', on: :collection
    get  'owner_videos', on: :collection
  end
  
end
