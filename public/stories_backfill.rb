json_data = File.read("#{Rails.public_path}/stories.json")
articles = JSON.parse(json_data)

articles.each do |article|
  doc = Document::Story.find_or_initialize_by(slug: article["Slug"])
  new_article = !doc.persisted?
  doc.title = article["Headline"]
  doc.published_at = article["PublishDate"].to_date rescue Date.today
  if article["HeaderImage"].present?
    doc.main_image = article["HeaderImage"]
  end
  doc.save
  sctr = 1
  doc.sections.destroy_all
  article["Sections"].each do |section|
    if section["SectionType"] == 0 #html_content
      docsec = doc.sections.create({
        type: "DocumentPart::HtmlContent",
        title: section["Title"] || "",
        content: section["Content"] || "",
        pane: "main",
        display_order: sctr
      })
    end
    if section["SectionType"] == 1 #full-width image(slideshow)
      if section["Images"].any?
        img_gallery = doc.sections.create({
          type: "DocumentPart::Slideshow",
          title: section["Title"] || "",
          content: section["Content"] || "",
          pane: "main",
          display_order: sctr
        })
        ictr = 1
        section["Images"].each do |image|
          next if image.blank?
          img = img_gallery.images.create({
          image: image.starts_with?("/static") ? "http://thefasthouse.com/#{image["MainImage"].gsub("/static", "")}" : image,
          caption: "",
          order: ictr
          })
          ictr += 1
        end
      end
    end
    if section["SectionType"] == 2 #image strip(gallery)
      if section["Images"].any?
        img_gallery = doc.sections.create({
          type: "DocumentPart::ImageGallery",
          title: section["Title"] || "",
          content: section["Content"] || "",
          pane: "main",
          display_order: sctr
        })
        ictr = 1
        section["Images"].each do |image|
          next if image.blank?
          img = img_gallery.images.create({
          image: image.starts_with?("/static") ? "http://thefasthouse.com/#{image["MainImage"].gsub("/static", "")}" : image,
          caption: "",
          order: ictr
          })
          ictr += 1
        end
      end
    end
  sctr += 1
  end
  article["Tags"].each do |tag|
    cat = Category.find_or_create_by(name: tag["Name"])
    dc = doc.document_categories.create({category_id: cat.id})
  end
end