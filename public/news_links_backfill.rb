json_data = File.read("#{Rails.public_path}/newslinks.json")
items = JSON.parse(json_data)

items.sort_by(&:Id).each do |item|
  rec = NewsLink.find_or_initialize_by(url_link: item["UrlLink"])
  rec.title = item["Title"]
  rec.publish_date = item["CreatedAt"].to_date rescue Date.today
  rec.author = item["Author"]
  rec.keywords = item["Keywords"]
  rec.hidden = item["Hidden"] || false
  rec.performance_only = item["PerformanceOnly"] || false
  rec.save
end