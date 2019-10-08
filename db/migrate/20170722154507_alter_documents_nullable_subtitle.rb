class AlterDocumentsNullableSubtitle < ActiveRecord::Migration[5.0]
  def change
    change_column :documents, :subtitle, :string, limit: 1000, null: true
  end
end
