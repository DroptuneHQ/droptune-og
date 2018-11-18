class VideoSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :release_date,
    :image,
    :source,
    :source_data,
    :created_at,
    :updated_at
end
