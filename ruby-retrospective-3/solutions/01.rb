class Integer
  def prime?
    dividers = 2..(self / 2).abs
    dividers.each do |divider|
      if self % divider == 0
        return false
      end
    end
    return true
  end

  def prime_factors
    factors = ->(n, fact_list) { return fact_list if n == 1
                                 factor = (2..n).find {|x| n % x == 0}
                                 factors.(n / factor, fact_list + [factor]) }
    return factors.(self.abs, fact_list = [])
  end

  def harmonic
    (1..self).to_a.map { |number| Rational(1, number) }.reduce(:+)
  end

  def digits
    abs.to_s.chars.map(&:to_i)
  end
end


class Array
  def frequencies
    frequency_hash = Hash.new(0)
    self.each { |element| frequency_hash[element] += 1 }
    return frequency_hash
  end

  def average
    sum = 0.0
    self.each { |element| sum += element}
    return sum / self.size
  end

    def drop_every(n)
    modified_array = self[0..self.size-1]
    current_index = n - 1
    while current_index < modified_array.length
      modified_array.delete_at(current_index)
      current_index += n - 1
    end
    return modified_array
  end

  def combine_with(other)
    combine = ->(combined, fst, snd) { return combined + snd if fst == []
                                       return combined + fst if snd == []
                                       combine.(combined + [fst[0]] + [snd[0]],
                                                fst[1..fst.size],
                                                snd[1..snd.size]) }
    return combine.(combined = [], self, other)
  end
end

