class CreatePerformanceHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :performance_histories do |t|
      t.string  :title, null: false
      t.string :composer
      t.integer :season
      t.string :performance_dates
      t.text  :content
      t.date    :first_performance_date
      t.timestamps
    end
  end
end
