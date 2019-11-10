class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :title, null: false, limit: 1000
      t.string :slug, null: false, limit: 1000
      t.integer :parent_id
      t.string :subtitle, null: false, limit: 1000
      t.attachment :main_image
      t.text :css
      t.text :scripts
      t.text :meta_data
      t.text :additional_data
      t.integer :order
      t.boolean :hidden
      t.integer :created_by
      t.datetime :published_at
      
      t.timestamps
    end
  end
end
