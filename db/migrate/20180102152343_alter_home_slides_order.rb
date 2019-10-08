class AlterHomeSlidesOrder < ActiveRecord::Migration[5.0]
  def change
    rename_column :home_slides, :order, :display_order
  end
end
