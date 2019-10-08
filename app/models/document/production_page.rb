class Document::ProductionPage < Document
  store :additional_data, accessors: [:crop_actions, :production_number], coder: JSON
  def page_type
    "production_page"
  end
  
  def self.page_type
    "production_page"
  end
  
  def production_page?
    true
  end
  
  def init_sections
    sec = self.sections.create(display_order: 0, layout: 'right-pane')
    sec.parts.create({
      type: "DocumentPart::HtmlContent",
      document_id: sec.document_id,
      title: "",
      content: "",
      section_pane: "main",
      display_order: 1
      })
    sec.parts.create({
      type: "DocumentPart::PerformancesSummary",
      document_id: sec.document_id,
      title: "",
      content: "",
      section_pane: "right",
      display_order: 1
      })
    sec = self.sections.create(display_order: 1, layout: 'full')
    sec.parts.create({
      type: "DocumentPart::CastList",
      document_id: sec.document_id,
      title: "Meet the Cast",
      content: "",
      section_pane: "main",
      display_order: 1
      })
    sec = self.sections.create(display_order: 2, layout: 'right-pane')
    sec.parts.create({
      type: "DocumentPart::TabContent",
      document_id: sec.document_id,
      title: "Synopsis",
      content: "",
      section_pane: "main",
      display_order: 2
      })
    sec.parts.create({
      type: "DocumentPart::PerformanceNews",
      document_id: sec.document_id,
      title: "",
      content: "",
      section_pane: "right",
      display_order: 1
      })
  end
end