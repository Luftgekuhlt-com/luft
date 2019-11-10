class Category < ApplicationRecord
  
  has_many :document_categories
  has_many :documents, through: :document_categories
  
  before_validation :set_slug
  validates_uniqueness_of :slug
  
  
  private
  
  def set_slug
    self.slug = self.name.parameterize if self.slug.blank?
    self.slug = self.slug.parameterize
  end
end
