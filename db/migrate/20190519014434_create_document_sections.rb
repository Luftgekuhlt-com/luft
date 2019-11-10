class CreateDocumentSections < ActiveRecord::Migration[5.0]
  def change
    create_table :document_sections do |t|
      t.references :document, index: true
      t.string :layout
      t.string :title
      t.text :additional_data
      t.integer :display_order
      t.boolean :hidden
      t.integer :created_by

      t.timestamps
    end
  end
end
