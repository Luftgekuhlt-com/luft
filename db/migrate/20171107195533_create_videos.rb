class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :title, null: false, limit: 1000
      t.string :sub_title, null: true, limit: 1000
      t.string :video_url, null: false, limit: 1000
      t.string :slug, null: false, limit: 1000
      t.string :caption, null: true, limit: 2000
      t.attachment :thumb_image
      t.text :additional_data
      t.integer :order
      t.boolean :hidden
      t.integer :created_by
      t.datetime :published_at
      
      t.timestamps
    end
  end
end
