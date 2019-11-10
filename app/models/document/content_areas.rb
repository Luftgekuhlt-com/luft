class Document::ContentAreas < Document
 
  def self.page_type
    "content_areas"
  end
  def init_sections
    self.sections.create({
      type: "DocumentPart::ImageGallery",
      title: "Product Features",
      content: "",
      pane: "main",
      display_order: 0
      })
    self.sections.create({
      type: "DocumentPart::ImageGallery",
      title: "Home Features",
      content: "",
      pane: "main",
      display_order: 1
      })
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "Footer",
      content: "",
      pane: "main",
      display_order: 2
      })
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "The Scene Header",
      content: "",
      pane: "main",
      display_order: 3
      })
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "Stories Header",
      content: "",
      pane: "main",
      display_order: 4
      })
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "Crew Header",
      content: "",
      pane: "main",
      display_order: 5
      })
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "Legends Header",
      content: "",
      pane: "main",
      display_order: 6
      })
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "History Header",
      content: "",
      pane: "main",
      display_order: 7
      })
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "Films Header",
      content: "",
      pane: "main",
      display_order: 8
      })
  end
end