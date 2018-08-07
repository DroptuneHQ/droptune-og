class Artist < ApplicationRecord
  has_many :albums
  has_many :follows, dependent:  :destroy
  has_many :users, -> { distinct }, through: :follows

  def to_param
    "#{id}-#{permalink}"
  end

private
  def permalink
    "#{name.parameterize}"
  end
end