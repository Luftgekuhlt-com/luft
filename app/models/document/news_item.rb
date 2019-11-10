class Document::NewsItem < Document
  def self.url_prefix
    'news'
  end
  def self.page_type
    "news_item"
  end
end