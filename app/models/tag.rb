class Tag < ApplicationRecord
  
  has_many :video_tags
  has_many :videos, through: :video_tags
  
  before_validation :set_slug
  validates_uniqueness_of :slug
  
  
  private
  
  def set_slug
    self.slug = self.name.parameterize if self.slug.blank?
    self.slug = self.slug.parameterize
  end
end
