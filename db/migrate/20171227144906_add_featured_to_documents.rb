class AddFeaturedToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :featured, :boolean, default: true
    add_column :documents, :expires_at, :datetime
  end
end
