class ChangeOrderColName < ActiveRecord::Migration[5.0]
  def change
    rename_column :document_parts, :order, :display_order
  end
end
