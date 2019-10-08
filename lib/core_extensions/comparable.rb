module Comparable
  def bounded_by(min, max)
    max, min = min, max if max < min
    num = min.nil? ? self : [self, min].max
    max.nil? ? num : [num, max].min
  end
end
