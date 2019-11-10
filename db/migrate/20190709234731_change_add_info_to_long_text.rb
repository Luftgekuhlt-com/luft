class ChangeAddInfoToLongText < ActiveRecord::Migration[5.0]
  def change
    change_column :document_parts, :additional_data, :longtext
  end
end
