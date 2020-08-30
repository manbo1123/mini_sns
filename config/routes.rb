Rails.application.routes.draw do
  # 各アクションをオーバーライドすることで、deviseが提供するアクションをカスタマイズ
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'           # ログインor新規登録を選ぶページ
  resources :users, only: :new  # 新規登録方法を選ぶページ
end
