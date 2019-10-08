class AddAttachmentMobileImageToHomeSlides < ActiveRecord::Migration
  def self.up
    change_table :home_slides do |t|
      t.attachment :mobile_image
    end
  end

  def self.down
    remove_attachment :home_slides, :mobile_image
  end
end
