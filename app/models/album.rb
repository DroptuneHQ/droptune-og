# == Schema Information
#
# Table name: albums
#
#  id                 :bigint(8)        not null, primary key
#  album_type         :string
#  applemusic_image   :string
#  applemusic_link    :string
#  artist_slug        :string
#  artwork_link       :text
#  name               :text
#  release_date       :date
#  spotify_image      :text
#  spotify_link       :text
#  spotify_popularity :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  applemusic_id      :bigint(8)
#  artist_id          :bigint(8)
#  spotify_id         :text
#
# Indexes
#
#  index_albums_on_album_type          (album_type)
#  index_albums_on_artist_id           (artist_id)
#  index_albums_on_artist_id_and_name  (artist_id,name)
#  index_albums_on_artist_slug         (artist_slug)
#  index_albums_on_name                (name)
#  index_albums_on_release_date        (release_date)
#  index_on_albums_release_date_month  (date_part('month'::text, release_date))
#  index_on_albums_release_date_year   (date_part('year'::text, release_date))
#

class Album < ApplicationRecord
  ## -- RELATIONSHIPS

  belongs_to :artist
  has_many :streams

  ## -- SCOPES

  scope :has_release_date, -> { where.not(release_date: nil) }
  scope :active, -> {where('follows.active = ?', true)}
  scope :for_month, ->(month) { where('extract(month from release_date) = ?', month) if month.present? }
  scope :for_year, ->(year) { where('extract(year from release_date) = ?', year) if year.present? }
  scope :for_types, ->(album_types) { where( album_type: album_types ) if album_types.present? }
  scope :types_for_user, ->(user) { where( album_type: Album.calculate_types_for_user(user) ) }

  scope :followed_by_user, ->(user) { where( artist: user.active_artists ) if user}

  scope :future_releases, -> { where("release_date > ?", Date.today) }
  scope :recent_releases, ->(days_ago) { where("release_date BETWEEN ? AND ?", days_ago.to_i.days.ago.to_date, Date.today) }

  scope :default_order, -> { order('release_date desc', 'artists.name asc') }

  ## -- CALLBACKS

  before_save :set_slug

  ## — CLASS METHODS

  def self.calculate_types_for_user(user = nil)
    album_types = ::Album.reorder(nil).select(:album_type).distinct.pluck(:album_type)
    if user
      album_types -= %w[compilation] if !user.settings['show_compilations']
      album_types -= %w[single]       if !user.settings['show_singles']
    else
      album_types -= %w[compilation single]
    end
    album_types
  end

  ## — INSTANCE METHODS

  def to_param
    "#{id}-#{permalink}"
  end

private
  def set_slug
    self.artist_slug = self.artist.name.parameterize if artist_slug.blank?
  end

  def permalink
    "#{self.artist_slug.parameterize}-#{name.parameterize}"
  end
end
