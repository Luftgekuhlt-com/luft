class CreateNewsLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :news_links do |t|
      t.string  :title, null: false
      t.string  :url_link, limit: 4000
      t.string  :author
      t.string  :keywords
      t.date    :publish_date
      t.boolean :hidden, default: false
      t.boolean :performance_only, default: false
      t.timestamps
    end
  end
end
