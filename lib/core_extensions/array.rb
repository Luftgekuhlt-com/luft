class Array
  def to_hist(sort = true)
    a = Hash.new
    each { |s| a[s] = (a[s] || 0) + 1 }
    sort ? a.sort_by_value_desc : a
  end

  def truncate(max_elements = 3, opts = {}, &block)
    return nil if nil?

    if count <= max_elements
      tr = self
    else
      template = opts.fetch(:template, 'and %d more')
      tr = block_given? ? self[0..max_elements - 2].map { |x| yield x } : self[0..max_elements - 2] 
      tr += [sprintf(template, length - max_elements + 1)]
    end
    opts.fetch(:to_s, false) ? tr.join(opts.fetch(:separator, ',')) : tr
  end

  def avg
    select { |x| x.is_numeric? }.sum.to_f / select { |x| x.is_numeric? }.count rescue nil 
  end

  def similarity(ar)
    jaccardSimilarity(ar)
  end

  def jaccardSimilarity(ar)
    return 1.0 if ar.length == 0 && length == 0

    lhist = to_hist(false)
    rhist = ar.to_hist(false)
    intersect = lhist.keys & rhist.keys
    union = lhist.keys | rhist.keys
    return 0.0 if union.empty?

    intersect.map { |x| [lhist[x], rhist[x]].compact.min }.sum.to_f / union.map { |x| [lhist[x], rhist[x]].compact.max }.sum
  end
end
