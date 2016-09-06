class CreateUserPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :user_preferences do |t|
      t.string :date_of_birth
      t.string :location
      t.string :color_theme
      t.string :topics

      t.timestamps
    end
  end
end
