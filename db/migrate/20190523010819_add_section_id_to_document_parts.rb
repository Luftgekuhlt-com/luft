class AddSectionIdToDocumentParts < ActiveRecord::Migration[5.0]
  def change
    add_column :document_parts, :document_section_id, :integer, null: false, default: 0
  end
end
