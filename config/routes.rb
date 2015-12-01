Rails.application.routes.draw do
  resource :campaign, :path => '/', only: [:show] do
    resource :theme, only: [:show, :edit, :update]
  end
end
