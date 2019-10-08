class AddArchivedToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :archived, :boolean
  end
end
