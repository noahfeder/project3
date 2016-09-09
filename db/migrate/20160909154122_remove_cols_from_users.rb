class RemoveColsFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :lat, :string
    remove_column :users, :lng, :string
  end
end
