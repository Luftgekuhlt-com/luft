class DocumentPart::PerformanceHistoriesList < DocumentPart

  def performance_histories
    @performance_histories ||= keywords.present? ? PerformanceHistory.where('title LIKE ?', "%#{keywords}%").order('season DESC, first_performance_date DESC').to_a : PerformanceHistory.order('season DESC, first_performance_date DESC').to_a
  end

  def seasons
    @seasons ||= performance_histories.map{|ph| ph.season}.sort.reverse.uniq
  end

  def season_items(season)
    performance_histories.select{|ph| ph.season == season}.sort_by(&:first_performance_date)
  end
end