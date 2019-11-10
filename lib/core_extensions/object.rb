class Object
  def to_bool
    ActiveRecord::Type::Boolean.new.type_cast_from_user(self)
  end

  def to_table
    if is_a?(Array)
      result = ['<table>']
      each do |x|
        result << "<tr><td>#{x.to_table}</td></tr>"
      end
      result << '</table>'
      return result.join("\n")
    elsif respond_to?(:keys)
      result = ['<table>']
      keys.each do |k|
        r = ["<tr><td>#{k}</td><td>"]
        if self[k].is_a?(Hash) || self[k].is_a?(Array)
          r << self[k].to_table
        else
          r << self[k].to_s
        end
        r << '</td></tr>'
        result << r.join('')
      end
      result << '</table>'
      return result.join("\n")
    end
    to_s
  end
end
