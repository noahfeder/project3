# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item       :string
#  completed  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Todo < ApplicationRecord
  belongs_to :user
end
