class CreateDocumentParts < ActiveRecord::Migration[5.0]
  def change
    create_table :document_parts do |t|
      t.references :document, index: true
      t.string :type
      t.string :title, null: false, limit: 1000
      t.text :content
      t.text :additional_data
      t.integer :order
      t.boolean :hidden
      t.integer :created_by

      t.timestamps
    end
  end
end
