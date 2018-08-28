class Connection < ApplicationRecord
  belongs_to :user
  serialize :settings

  scope :spotify, -> { where(provider: 'spotify') }
end
