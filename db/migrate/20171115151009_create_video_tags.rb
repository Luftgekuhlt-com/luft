class CreateVideoTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end
    create_table :video_tags do |t|
      t.references :video
      t.references :tag
      t.timestamps
    end
  end
end
