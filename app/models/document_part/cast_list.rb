class DocumentPart::CastList < DocumentPart
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