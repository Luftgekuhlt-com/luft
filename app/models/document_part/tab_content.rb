class DocumentPart::TabContent < DocumentPart
  store :additional_data, accessors: [:mobile_content, :section_pane, :tabs], coder: JSON
  
  
end