# == Schema Information
#
# Table name: users
#
#  id                         :bigint(8)        not null, primary key
#  admin                      :boolean          default(FALSE)
#  apple_music_token          :text
#  applemusic_connected_at    :datetime
#  applemusic_disconnected_at :datetime
#  avatar                     :string
#  current_sign_in_at         :datetime
#  current_sign_in_ip         :inet
#  email                      :citext           default("")
#  encrypted_password         :string           default(""), not null
#  last_sign_in_at            :datetime
#  last_sign_in_ip            :inet
#  name                       :string
#  provider                   :string
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  settings                   :jsonb            not null
#  sign_in_count              :integer          default(0), not null
#  spotify_connected_at       :datetime
#  spotify_disconnected_at    :datetime
#  uid                        :string
#  username                   :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  has_many :follows, dependent:  :destroy
  has_many :artists, through: :follows
  has_many :active_artists, ->{where(follows: { active: true }) }, through: :follows, source: :artist
  has_many :albums, through: :artists
  has_many :music_videos, through: :artists

  include Storext.model
  store_attributes :settings do
    show_compilations Boolean, default: false
    show_singles Boolean, default: true
    show_remixes Boolean, default: true
    show_live Boolean, default: true
    weekly_report Boolean, default: true
    private_profile Boolean, default: true
    generate_playlist_spotify Boolean, default: false
    generate_playlist_spotify_id String, default: nil
    generate_playlist_applemusic Boolean, default: false
    generate_playlist_applemusic_id String, default: nil
    generate_playlist_frequency String, default: 'daily'
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[twitter spotify]

  has_many :connections

  def email_required?
    false
  end

  def is_admin?
    admin
  end

  def has_spotify?
    if self.connections.where(provider:'spotify').first.present?
      true
    else
      false
    end
  end

  def has_apple_music?
    if self.apple_music_token.present?
      true
    else
      false
    end
  end

  def to_param
    @to_param ||= [id, screename.parameterize].join("-")
  end

  def screename
    if username.blank?
      Faker::FunnyName.name
    else
      username
    end
  end

  def fauxvatar
    seed = "#{id}#{email.to_s.gsub('-','')}".to_i
    topType = ['NoHair','Eyepatch','Hat','Hijab','Turban','LongHairBigHair','LongHairBob','LongHairBun','LongHairCurly','LongHairCurvy','LongHairDreads','LongHairFrida','LongHairFro','LongHairFroBand','LongHairNotTooLong','LongHairShavedSides','LongHairMiaWallace','LongHairStraight','LongHairStraight2','LongHairStraightStrand','ShortHairDreads01','ShortHairDreads02','ShortHairFrizzle','ShortHairShaggyMullet','ShortHairShortCurly','ShortHairShortFlat','ShortHairShortRound','ShortHairShortWaved','ShortHairSides','ShortHairTheCaesar','ShortHairTheCaesarSidePart','WinterHat1','WinterHat2','WinterHat3','WinterHat4']
    accessoriesType = ['Blank','Blank','Blank','Blank','Blank','Blank','Blank','Blank','Blank','Kurt','Prescription01','Prescription02','Round','Sunglasses','Wayfarers']
    hairColor = ['Auburn','Black','Blonde','BlondeGolden','Brown','BrownDark','PastelPink','Platinum','Red','SilverGray']
    hatColor = ['Black','Blue01','Blue02','Blue03','Gray01','Gray02','Heather','PastelBlue','PastelGreen','PastelOrange','PastelRed','PastelYellow','Pink','Red','White']
    facialHairType = ['Blank','BeardMedium','BeardLight','BeardMagestic','MoustacheFancy','MoustacheMagnum']
    facialHairColor = ['Auburn','Black','Blonde','BlondeGolden','Brown','BrownDark','Platinum','Red']
    clotheType = ['BlazerShirt','BlazerSweater','CollarSweater','GraphicShirt','Hoodie','Overall','ShirtCrewNeck','ShirtScoopNeck','ShirtVNeck']
    clotheColor = ['Black','Blue01','Blue02','Blue03','Gray01','Gray02','Heather','PastelBlue','PastelGreen','PastelOrange','PastelRed','PastelYellow','Pink','Red','White']
    graphicType = ['Bat','Cumbia','Deer','Diamond','Hola','Pizza','Resist','Selena','Bear','SkullOutline','Skull']
    eyeType = ['Close','Cry','Default','Dizzy','EyeRoll','Happy','Side','Squint','Surprised','Wink','WinkWacky']
    eyebrowType = ['Angry','AngryNatural','Default','DefaultNatural','FlatNatural','RaisedExcited','RaisedExcitedNatural','SadConcerned','SadConcernedNatural','UnibrowNatural','UpDown','UpDownNatural']
    mouthType = ['Concerned','Default','Disbelief','Eating','Grimace','Sad','ScreamOpen','Serious','Smile','Tongue','Twinkle']
    skinColor = ['Tanned','Yellow','Pale','Light','Brown','DarkBrown','Black']

    url = "?topType=#{topType.sample(random: Random.new(seed+1))}&accessoriesType=#{accessoriesType.sample(random: Random.new(seed+2))}&hairColor=#{hairColor.sample(random: Random.new(seed+3))}&facialHairType=#{facialHairType.sample(random: Random.new(seed+4))}&facialHairColor=#{facialHairColor.sample(random: Random.new(seed+5))}&clotheType=#{clotheType.sample(random: Random.new(seed+6))}&clotheColor=#{clotheColor.sample(random: Random.new(seed+7))}&graphicType=#{graphicType.sample(random: Random.new(seed+8))}&eyeType=#{eyeType.sample(random: Random.new(seed+9))}&eyebrowType=#{eyebrowType.sample(random: Random.new(seed+10))}&mouthType=#{mouthType.sample(random: Random.new(seed+11))}&skinColor=#{skinColor.sample(random: Random.new(seed+12))}&hatColor=#{hatColor.sample(random: Random.new(seed+12))}"
    "https://avataaars.io/#{url}"
  end

  def avatar_image
    if username
      "https://unavatar.io/twitter/#{username}"
    else
      fauxvatar
    end
  end

  def self.create_from_provider_data(provider_data)
    user = User.find_or_initialize_by(provider: provider_data.provider, uid: provider_data.uid)

    user.email = provider_data.info.email
    user.username = provider_data.info.nickname
    user.name = provider_data.info.name
    user.avatar = provider_data.info.image
    user.password = Devise.friendly_token[0, 20]
    user.save

    if user.created_at > 10.seconds.ago
      UserMailer.with(user: user).welcome_email.deliver_now
    end

    user
  end

  protected
  def extract_ip_from(request)
    if request.headers["X-Forwarded-For"].present?
      request.headers["X-Forwarded-For"]
    else
      request.remote_ip
    end
  end
end
