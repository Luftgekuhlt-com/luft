class AddQbAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :qb_access_token, :string
    add_column :users, :qb_access_secret, :string
    add_column :users, :qb_company_id, :string
    add_column :users, :qb_token_expires_at, :datetime
  end
end
