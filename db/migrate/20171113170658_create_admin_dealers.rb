class CreateAdminDealers < ActiveRecord::Migration[5.0]
  def change
    create_table :dealers do |t|
      t.string :name, null: false
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone
      t.string :website, limit: 1000

      t.timestamps
    end
  end
end
