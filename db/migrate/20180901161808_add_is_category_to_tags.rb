class AddIsCategoryToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :is_category, :boolean, default: false
  end
end
