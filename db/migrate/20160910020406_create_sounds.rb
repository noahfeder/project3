class CreateSounds < ActiveRecord::Migration[5.0]
  def change
    create_table :sounds do |t|
      t.string :genre
      t.string :embed_info

      t.timestamps
    end
  end
end
