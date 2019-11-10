class DocumentPart::Video < DocumentPart
  def video_url
    content.presence || ""
  end
  def html5?
    video_url.downcase.include?(".mp4")
  end

  def vimeo?
    video_url.downcase.include?("vimeo")
  end

  def vimeo_id
    video_url.split("?").first.split("/").last
  end

  def youtube?
    video_url.downcase.include?("youtube") || video_url.downcase.include?("youtu.be")
  end

  def youtube_id
    video_url.include?("v=") ? video_url.split("v=").last.split("&").first : video_url.split("?").first.split("/").last
  end

  def player_html
    markup = ""
    if vimeo?
      markup = %Q(<iframe webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" src="//player.vimeo.com/video/#{vimeo_id}?title=0&byline=0&portrait=0&color=ffffff&autoplay=0" style="width:100%;max-width:100%;height:600px;" frameborder="0"></iframe>)
    end
    if youtube?
      markup = %Q(<iframe width="100%" height="600" src="https://www.youtube.com/embed/#{youtube_id}?rel=0&autoplay=0" frameborder="0" style="width:100%;max-width:100%;" allowfullscreen></iframe>)
    end
    if html5?
    markup = %Q(<div class="html5-video-wrap"><video width="100%" height="100%" controls><source src="#{video_url}" type="video/mp4"></video></div>)
    end
    markup
  end
end