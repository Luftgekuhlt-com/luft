module I18n
  def self.default_locale?; locale == default_locale end
  def self.language
    locale.to_s.split('_').first
  end
end
