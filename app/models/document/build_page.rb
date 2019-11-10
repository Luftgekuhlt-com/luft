class Document::BuildPage < Document
  def self.url_prefix
    'builds'
  end
  def self.page_type
    "build_page"
  end
end