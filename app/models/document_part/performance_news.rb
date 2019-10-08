class DocumentPart::PerformanceNews < DocumentPart
  def production_number
    document.production_number
  end
  
  def production
    Production.find(production_number) if production_number.present?
  end
  
  def news_items
    []
  end
end