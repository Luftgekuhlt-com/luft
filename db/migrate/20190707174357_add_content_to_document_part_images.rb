class AddContentToDocumentPartImages < ActiveRecord::Migration[5.0]
  def change
    add_column :document_part_images, :content, :text
  end
end
