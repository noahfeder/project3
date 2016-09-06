class RemovePwDigestFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :pw_digest, :string
  end
end
