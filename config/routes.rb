Rails.application.routes.draw do
  resource :website, :path => '/', only: [:show] do
    resource :theme, only: [:show, :edit, :update] do
      patch :preview, on: :collection
    end
  end
end
