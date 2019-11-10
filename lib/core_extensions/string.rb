class String
  BOOLEAN_CONVERTER = ActiveRecord::Type::Boolean.new

  def remove_non_ascii(replacement = '')
    scan(/[[:print:]]/).join
  end

  def is_numeric?
    Float self rescue false
  end

  def to_bool
    BOOLEAN_CONVERTER.deserialize(downcase.strip)
  end

  def bigrams
    return [] if length < 2

    (0..length - 2).map { |x| self[x..(x + 1)] }
  end

  def similarity(other)
    return 1.0 if self == other

    bigramSimilarity(other)
  end

  def most_similar_substring(other)
    return 1.0 if self == other
    return similarity(other) if length == other.length
    return 0.0 if other.length > length

    i = 0
    best_score = 0.0
    all_scores = []
    while i.present?
      i = index other[0], i
      break if  i.nil?

      score = self[i..i + other.length - 1].similarity(other)
      all_scores << [score, self[i..i + other.length - 1]].join('^')
      best_score = [best_score, score].max
      # puts [i, self[i..i+other.length-1], score, best_score].join(' ')
      i += 1
    end
    # puts all_scores
    best_score

  end

  def bigramSimilarity(other)
    bigrams.similarity(other.bigrams)
  end

  def levenshteinDistance(other)
    return 0 if self == other
    return length if other.empty?
    return other.length if empty?

    v0 = (0..other.length).to_a
    v1 = Array.new(other.length + 1) { |i| 0 }

    split('').each_index do |i|
      v1[0] = i + 1;

      other.split('').each_index do |j|
        cost = self[i] == other[j] ? 0 : 1
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].min;
      end

      v1.each_index { |i| v0[i] = v1[i] }
    end
    v1.last
  end

  def hammingDistance(other)
    return 0 if self == other

    extra = (length - other.length).abs
    min = [length, other.length].min

    sum = (0..min).map { |i| self[i] == other[i] ? 0 : 1 }.sum
    sum + extra
  end
end
