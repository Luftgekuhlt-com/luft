class Admin::HomeController < AdminController
  def index
    
  end
  
  def content
    @content_areas = Document.find_or_create_by(slug: "content-areas", type: "Document::ContentAreas", title: "Content Areas")
  end
end