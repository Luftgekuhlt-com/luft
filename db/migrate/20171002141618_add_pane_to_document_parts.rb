class AddPaneToDocumentParts < ActiveRecord::Migration[5.0]
  def change
    add_column :document_parts, :pane, :string, default: "main"
  end
end
