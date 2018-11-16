# == Schema Information
#
# Table name: connections
#
#  id         :bigint(8)        not null, primary key
#  provider   :string
#  settings   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint(8)
#
# Indexes
#
#  index_connections_on_provider  (provider)
#  index_connections_on_user_id   (user_id)
#

require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
