class AddUserToUserPreference < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_preferences, :user, foreign_key: true
  end
end
