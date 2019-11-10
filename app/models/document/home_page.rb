class Document::HomePage < Document

  def self.page_type
    "home_page"
  end
  
  def partial_page?
    false
  end
end