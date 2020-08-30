class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter, :facebook, :google_oauth2]

  has_many :sns_credentials

  kanji = /\A[一-龥ぁ-ん]/
  kana = /\A([ァ-ン]|ー)+\z/
  
  validates :nickname, :lastname, :firstname, :lastname_kana, :firstname_kana, :birthday, presence: true
  validates :lastname, format: { with: kanji }
  validates :firstname, format: { with: kanji }
  validates :lastname_kana, format: { with: kana }
  validates :firstname_kana, format: { with: kana }


  # omniauthのコールバック時に呼ばれるメソッドを定義
  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create

    # 過去にsns認証してれば、アソシエーションで取得
    # 無ければemailでユーザー検索して取得 or ビルド(保存はしない)
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
      email: auth.info.email
    )
    # 登録済みユーザーなら、ログインの処理へ行くので、ここでsnsのuser_idを更新
    if user.persisted?
      sns.user = user
      sns.save
    end
    { user: user, sns: sns }
  end
end
