class ChangeOrderColImages < ActiveRecord::Migration[5.0]
  def change
    rename_column :document_part_images, :order, :display_order
  end
end
