class CreateHomeSlides < ActiveRecord::Migration[5.0]
  def change
    create_table :home_slides do |t|
      t.string :title, null: false, limit: 1000
      t.string :sub_title, null: true, limit: 1000
      t.string :video_url, null: true, limit: 1000
      t.string :button_link, null: true, limit: 1000
      t.string :button_text, null: true, limit: 1000
      t.string :caption, null: true, limit: 2000
      t.attachment :main_image
      t.text :content
      t.text :additional_data
      t.integer :order
      t.boolean :hidden
      t.integer :created_by
      t.datetime :start_date
      t.datetime :end_date
      
      t.timestamps
    end
  end
end
