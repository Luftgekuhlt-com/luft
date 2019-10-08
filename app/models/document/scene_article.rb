class Document::SceneArticle < Document
  def page_type
    "scene_article"
  end
  def self.page_type
    "scene_article"
  end
  def init_sections
    self.sections.create({
      type: "DocumentPart::HtmlContent",
      title: "",
      content: "",
      pane: "left",
      display_order: 0
      })
    self.sections.create({
      type: "DocumentPart::ImageGallery",
      title: "",
      content: "",
      pane: "right",
      display_order: 0
      })
  end
end