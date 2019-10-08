json_data = File.read("#{Rails.public_path}/pressreleases.json")
items = JSON.parse(json_data)

items.sort_by(&:CreatedAt).each do |item|
  rec = PressRelease.find_or_initialize_by(title: item["Title"])
  rec.title = item["Title"]
  rec.publish_date = item["CreatedAt"].to_date rescue Date.today
  rec.word_doc = item["DocUrl"]
  rec.pdf_doc = item["PdfUrl"]
  rec.keywords = item["Keywords"]
  rec.hidden = item["Hidden"] || false
  rec.save
end