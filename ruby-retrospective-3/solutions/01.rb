class Integer
  def prime?
    return false if self < 1
    2.upto(self/2).none? { |number| remainder(number).zero? }
  end

  def prime_factors
    return [] if n == 1
    factor = (2..n).find {|x| n % x == 0}
    [factor] + (n / factor).prime_factors
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
    frequency_hash
  end

  def average
    reduce(:+).to_f / length unless length.zero?  
  end

  def drop_every(n)
    each_slice(n).map { |slice| slice.take(n - 1) }.reduce(:+) or []
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