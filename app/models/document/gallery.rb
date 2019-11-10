class Document::Gallery < Document
  belongs_to :past_event, class_name: 'Document::PastEvent', foreign_key: :parent_id
  
  def self.url_prefix
    'galleries'
  end
  def self.page_type
    "gallery"
  end

  def init_sections
    sec = self.sections.create(display_order: 0, layout: 'full')
    sec.parts.create({
      type: "DocumentPart::ImageGallery",
      document_id: sec.document_id,
      title: "",
      content: "",
      pane: "main",
      display_order: 1
      })
  end
end