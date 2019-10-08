class Document::HomeSpotlight < Document
  def page_type
    "home_spotlight"
  end
  def self.page_type
    "home_spotlight"
  end
  
  def partial_page?
    true
  end
end