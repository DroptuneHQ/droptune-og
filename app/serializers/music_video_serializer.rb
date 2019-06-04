# == Schema Information
#
# Table name: music_videos
#
#  id           :bigint(8)        not null, primary key
#  artist_slug  :string
#  image        :string
#  name         :string
#  release_date :date
#  source       :string
#  source_data  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  artist_id    :bigint(8)
#
# Indexes
#
#  index_music_videos_on_artist_id                  (artist_id)
#  index_music_videos_on_artist_id_and_source_data  (artist_id,source_data)
#  index_music_videos_on_artist_slug                (artist_slug)
#

class MusicVideoSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :release_date,
    :image,
    :source,
    :source_data,
    :created_at,
    :updated_at
end
