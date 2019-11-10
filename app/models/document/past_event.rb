class Document::PastEvent < Document
  has_many :storylines, class_name: 'Document::Storyline', foreign_key: :parent_id
  has_many :galleries, class_name: 'Document::Gallery', foreign_key: :parent_id
  has_many :news_items, class_name: 'Document::NewsItem', foreign_key: :parent_id
  has_one :products, class_name: 'DocumentPart::ImageGallery', foreign_key: :document_id
  
  def self.url_prefix
    'past-events'
  end
  def self.page_type
    "past_event"
  end
end