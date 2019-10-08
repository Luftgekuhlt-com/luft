json_data = File.read("#{Rails.public_path}/scene.json")
articles = JSON.parse(json_data)
errors = []
articles.each do |article|
  begin
doc = Document::SceneArticle.find_or_initialize_by(slug: article["Slug"])
new_article = !doc.persisted?
doc.title = article["Headline"]
doc.published_at = article["ArticleDate"].to_date rescue Date.today
feature_img = article["Images"].find{|i| i["Featured"]}
feature_img ||= article["Images"].find{|i| i["MainImage"].present?}
doc.main_image = feature_img["MainImage"].starts_with?("/static") ? "http://thefasthouse.com#{feature_img["MainImage"]}" : feature_img["MainImage"] if feature_img.present?
doc.save
doc.sections.destroy_all
body = doc.sections.create({
type: "DocumentPart::HtmlContent",
title: "",
content: article["Body"],
pane: "left",
display_order: 1
})
if article["VideoUrl"].present?
video = doc.sections.create({
type: "DocumentPart::Video",
title: "",
content: article["VideoUrl"],
pane: "right",
display_order: 1
})
end
imgs = doc.sections.create({
type: "DocumentPart::ImageGallery",
title: "",
content: "",
pane: "right",
display_order: 2
})
ctr = 1
article["Images"].each do |image|
next if image["MainImage"].blank?
img = imgs.images.create({
image: image["MainImage"].starts_with?("/static") ? "http://thefasthouse.com#{image["MainImage"]}" : image["MainImage"],
caption: image["Caption"] || "",
featured: image["Featured"],
display_order: ctr
})
ctr += 1
end
article["Tags"].each do |tag|
cat = Category.find_by(name: tag["Name"])
if cat.present?
dc = doc.document_categories.create({category_id: cat.id})
end
end
rescue
errors << article
end
end