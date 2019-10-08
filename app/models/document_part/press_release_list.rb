class DocumentPart::PressReleaseList < DocumentPart

  def press_releases
    @press_releases ||= keywords.present? ? PressRelease.where('keywords LIKE ?', "%#{keywords}%").order('publish_date DESC') : PressRelease.all.order('publish_date DESC')
  end
end