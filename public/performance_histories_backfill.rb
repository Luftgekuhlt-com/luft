json_data = File.read("#{Rails.public_path}/performancehistories.json")
items = JSON.parse(json_data)

items.sort_by(&:FirstPerformance).each do |item|
  rec = PerformanceHistory.find_or_initialize_by(performance_dates: item["PerfDates"], season: item["Season"])
  rec.title = item["Title"]
  rec.first_performance_date = item["FirstPerformance"].to_date rescue Date.today
  rec.composer = item["Composer"]
  rec.performance_dates = item["PerfDates"]
  rec.content = item["Content"]
  rec.season = item["Season"]
  rec.save
end