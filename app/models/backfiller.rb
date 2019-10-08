class Backfiller
  def self.backfill_scene_articles
    json_data = File.read("#{Rails.public_path}/scene.json")
    articles = JSON.parse(json_data)
    
    articles.each do |article|
      doc = Document::SceneArticle.find_or_initialize_by(slug: article["Slug"])
      doc.title = article["Headline"]
      doc.article_date = article["ArticleDate"].to_date rescue Date.today
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
          image: image["MainImage"].starts_with?("/static") ? "http://thefasthouse.com/#{image["MainImage"]}" : image["MainImage"],
          caption: image["Caption"] || "",
          featured: image["Featured"],
          order: ctr
        })
        ctr += 1
      end
      article["Tags"].each do |tag|
        cat = Category.find_by(name: tag["Name"])
        if cat.present?
          dc = doc.document_categories.create({category_id: cat.id})
        end
      end
    end
  end
  
  
  def self.backfill_videos
    json_data = File.read("#{Rails.public_path}/videos.json")
    videos = JSON.parse(json_data)
    ctr = videos.size
    videos.reverse.each do |video|
      slug = video["title"].parameterize rescue video["slug"]
      vid = Video.find_or_initialize_by(slug: slug)
      title_parts = video["title"].split("|").map{|x| x.strip} rescue [video["title"]]
      vid.title = title_parts.first
      vid.sub_title = title_parts.second if title_parts.size > 0
      vid.published_at = ctr.days.ago
      vid.video_url = video["url"]
      img_url = video["image"]
      img_url = "http://thefasthouse.com#{img_url}" if img_url.starts_with?("/")
      vid.thumb_image = img_url
      vid.save
      ctr -= 1
    end
  end
  
  def self.backfill_dealers
    json_data = File.read("#{Rails.public_path}/dealers.json")
    dealers = JSON.parse(json_data)
    dealers.each do |item|
      dealer = Dealer.find_or_initialize_by(name: item["Name"], address: item["Address"])
      dealer.address2 = item["Address2"] || ""
      dealer.city = item["City"]
      dealer.state = item["State"]
      dealer.postal_code = item["PostalCode"]
      dealer.phone = item["Phone"]
      dealer.website = item["WebsiteLink"]
      dealer.save
    end
  end
end