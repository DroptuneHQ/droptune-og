class Connection < ApplicationRecord
  belongs_to :user
  serialize :settings
end
