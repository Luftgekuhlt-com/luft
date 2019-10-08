class Hash
  def sort_by_key
    sort_by { |k, v| k }.inject(Hash.new { |h, k| h[k] = [] }) { |h, (k, v)| h[k] = v; h }
  end
  def sort_by_key_desc
    sort_by { |k, v| k }.reverse.inject(Hash.new { |h, k| h[k] = [] }) { |h, (k, v)| h[k] = v; h }
  end
  def sort_by_value
    sort_by { |k, v| v }.inject(Hash.new { |h, k| h[k] = [] }) { |h, (k, v)| h[k] = v; h }
  end
  def sort_by_value_desc
    sort_by { |k, v| -v }.inject(Hash.new { |h, k| h[k] = [] }) { |h, (k, v)| h[k] = v; h }
  end

  def similarity(other, weights = {})
    detailed_similarity(other, weights)[:score]
  end

  def method_missing(method, *args, &block)
    fetch(method) { self[method.to_s] }
  end

  def detailed_similarity(other, weights = {})
    return { score: 1.0, nonmatch_score: 0.0 } if self == other
    return { score: 0.0, nonmatch_score: 0.0 } if nil? || other.nil?
    return { score: 0.0, nonmatch_score: 0.0 } unless respond_to?(:keys) && other.respond_to?(:keys)

    union = keys | other.keys
    return { score: 0.0, nonmatch_score: 0.0 } if union.count == 0

    details = {}
    weighted_details = {}

    tot = 0.0
    sum = 0.0
    match_count = 0
    union.each do |k|
      next if weights[k] == 0

      t = if has_key?(k) && other.has_key?(k)
            if self[k].is_a?(Hash) && other[k].is_a?(Hash)
              self[k].similarity(other[k], weights)
            elsif self[k].is_a?(Array) && other[k].is_a?(Array)
              self[k].similarity(other[k])
            else
              self[k].to_s.similarity(other[k].to_s)
            end
          else
            0.0
          end
      details[k] = t
      weighted_details[k] = t * (weights[k] || 1.0)
      match_count += 1 if t == 1.0
      tot += t * (weights[k] || 1.0)
      sum += (weights[k] || 1.0)
    end
    { score: tot / sum, key_count: union.count, details: details, weighted_details: weighted_details, match_count: match_count, match_percent: match_count / sum, nonmatch_score: (tot - match_count) / (sum - match_count) }
  end

  def deep_transform_values(&block)
    each_with_object({}) do |(k, v), other|
      other.update(k => v.is_a?(Hash) ? v.deep_transform_values(&block) : block.call(v))
    end
  end

  def deep_diff(b)
    a = self
    (a.keys | b.keys).inject({}) do |diff, k|
      if a[k] != b[k]
        if a[k].respond_to?(:deep_diff) && b[k].respond_to?(:deep_diff)
          diff[k] = a[k].deep_diff(b[k])
        else
          diff[k] = [a[k], b[k]]
        end
      end
      diff
    end
  end
end
