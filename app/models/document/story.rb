class Document::Story < Document
  def page_type
    "story"
  end
  def self.page_type
    "story"
  end
  private
  
  def init_sections
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "",
      content: "",
      pane: "main",
      display_order: 1
      })
  end
end