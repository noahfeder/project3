class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :sectionId
      t.string :webPublicationDate
      t.string :webTitle
      t.string :webUrl
      t.string :type

      t.timestamps
    end
  end
end
