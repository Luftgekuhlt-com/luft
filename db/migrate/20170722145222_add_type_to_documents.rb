class AddTypeToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :type, :string
  end
end
