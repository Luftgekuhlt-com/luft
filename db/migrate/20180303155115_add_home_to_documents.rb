class AddHomeToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :home, :boolean, default: false
  end
end
