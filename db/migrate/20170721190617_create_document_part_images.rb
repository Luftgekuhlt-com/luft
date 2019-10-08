class CreateDocumentPartImages < ActiveRecord::Migration[5.0]
  def change
    create_table :document_part_images do |t|
      t.references :document_part, index: true
      t.string :title, limit: 1000
      t.string :caption, limit: 1000
      t.string :link_url, limit: 1000
      t.attachment :image
      t.text :crop_actions
      t.integer :order
      t.boolean :hidden
      t.boolean :featured

      t.timestamps
    end
  end
end
