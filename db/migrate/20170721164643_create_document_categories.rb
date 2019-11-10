class CreateDocumentCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :document_categories do |t|
      t.references :document, index: true
      t.references :category, index: true
      
      t.timestamps
    end
  end
end
