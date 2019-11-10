class CreateHomePortals < ActiveRecord::Migration[5.0]
  def change
    create_table :home_portals do |t|
      t.string :category, null: false, default: 'primary'
      t.string :title, null: false, limit: 1000
      t.string :link_url_1, null: true, limit: 1000
      t.string :link_text_1, null: true, limit: 1000
      t.string :link_url_2, null: true, limit: 1000
      t.string :link_text_2, null: true, limit: 1000
      t.attachment :main_image
      t.attachment :mobile_image
      t.text :content
      t.text :additional_data
      t.integer :display_order
      t.boolean :hidden
      t.integer :created_by
      t.date :start_date
      t.date :end_date
      
      t.timestamps
    end
  end
end
