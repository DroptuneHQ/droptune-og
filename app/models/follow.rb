class Follow < ApplicationRecord
  belongs_to :artist
  belongs_to :user

  def unfollow
    self.update_attributes(active: false)
  end
end
