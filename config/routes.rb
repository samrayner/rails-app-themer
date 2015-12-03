Rails.application.routes.draw do
  root 'websites#show'
  resource :website, :path => '/', only: [:show] do
    resource :theme, only: [:show, :edit, :update] do
      patch :preview, on: :collection
    end
  end
end
