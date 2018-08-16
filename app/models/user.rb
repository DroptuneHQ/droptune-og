class User < ApplicationRecord
  has_many :follows, dependent:  :destroy
  has_many :artists, -> { distinct }, through: :follows
  has_many :albums, through: :artists
  
  include Storext.model
  store_attributes :settings do
    show_compilations Boolean, default: false
    show_singles Boolean, default: false
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[twitter spotify]

  has_many :connections

  def to_param
    "#{id}-#{permalink}"
  end

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do | user |
      user.email = provider_data.info.email
      user.username = provider_data.info.nickname
      user.name = provider_data.info.name
      user.avatar = provider_data.info.image
      user.password = Devise.friendly_token[0, 20]
    end
  end

private
  def permalink
    "#{username.parameterize}"
  end
end
