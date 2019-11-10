class Document::Storyline < Document
  belongs_to :past_event, class_name: 'Document::PastEvent', foreign_key: :parent_id
  
  def self.page_type
    "storyline"
  end
end