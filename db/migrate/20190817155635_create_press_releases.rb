class CreatePressReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :press_releases do |t|
      t.string  :title, null: false
      t.text  :content
      t.attachment  :word_doc
      t.attachment  :pdf_doc
      t.string  :keywords
      t.date    :publish_date
      t.boolean :hidden, default: false
      t.timestamps
    end
  end
end
