# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def twitter
    authorization
  end

  def facebook
    authorization
  end

  def google_oauth2
    authorization
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  def failure
  #   super
    redirect_to root_path
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private
  def authorization  # APIから受け取ったレスポンスが request.env["omniauth.auth"]変数に入ってる
    # deviseのヘルパーを使うために、＠user に代入
    # User.from_omniauthは、Userモデルで定義
    sns_info = User.from_omniauth(request.env["omniauth.auth"])
    @user = sns_info[:user]

    if @user.persisted?   # 登録済みユーザー: ログイン処理へ
      sign_in_and_redirect @user, event: :authentication
    else                  # 未登録ユーザー: 新規登録画面へ遷移
      @sns_id = sns_info[:sns].id
      render template: 'devise/registrations/new'
    end
  end
end
