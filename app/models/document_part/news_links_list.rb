class DocumentPart::NewsLinksList < DocumentPart

  def news_links
    @news_links ||= keywords.present? ? NewsLink.where('keywords LIKE ?', "%#{keywords}%").order('publish_date DESC') : NewsLink.all.order('publish_date DESC')
  end
end