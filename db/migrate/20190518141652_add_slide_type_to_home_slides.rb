class AddSlideTypeToHomeSlides < ActiveRecord::Migration[5.0]
  def change
    add_column :home_slides, :slide_type, :string, default: 'basic'
  end
end
