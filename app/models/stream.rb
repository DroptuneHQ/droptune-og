class Stream < ApplicationRecord
  belongs_to :artist
  belongs_to :album
  belongs_to :user
end
