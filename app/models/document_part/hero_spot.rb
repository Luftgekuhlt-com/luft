class DocumentPart::HeroSpot < DocumentPart
  store :additional_data, accessors: [:subtitle, :button_url, :button_text], coder: JSON
  has_one :hero_image, class_name: "DocumentPartImage", foreign_key: :document_part_id
  def grid_column_class
    if third_width?
        'm12'
    elsif half_width?
        'm6'
    else
        'm3'
    end
  end
end