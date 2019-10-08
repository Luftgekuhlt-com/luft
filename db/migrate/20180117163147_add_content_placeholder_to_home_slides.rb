class AddContentPlaceholderToHomeSlides < ActiveRecord::Migration[5.0]
  def change
    add_column :home_slides, :content_anchor, :string, default: "left"
  end
end
