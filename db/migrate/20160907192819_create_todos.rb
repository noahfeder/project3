class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.references :user, foreign_key: true
      t.string :item
      t.boolean :completed

      t.timestamps
    end
  end
end
