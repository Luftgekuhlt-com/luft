class Document::History < Document
  def page_type
    "history"
  end
  def self.page_type
    "history"
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