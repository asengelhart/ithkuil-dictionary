require_relative './pattern'
require 'pry'
class Root
  attr_reader :value, :translation, :derivations
  @@all = []

  def initialize(value, translation, derivations = nil)
    @value = value
    @translation = translation
    @derivations = derivations
    @@all << self
  end
end

class BasicRoot < Root
  def initialize(value, translation, derivations = nil)
    super(value, translation, derivations)
    @patterns = { informal: Array.new(3), formal: Array.new(3) }
  end

  def add_patterns(pattern_or_array)
    pattern_array = [pattern_or_array] unless pattern_or_array.class == Array
    pattern_array.each do |pattern|
      # binding.pry
      @patterns[pattern.designation][pattern.pattern_num - 1] = pattern
    end
  end

  def patterns(designation = nil, pattern_num = nil)
    if designation.nil?
      return @patterns
    elsif pattern_num.nil?
      return @patterns[designation]
    else
      return @patterns[designation][pattern_num - 1]
    end
  end
end

class DerivedRoot < Root
  attr_reader :base_root
  def initialize(value, translation, base_root)
    super(value, translation)
    @base_root = base_root
  end

  def patterns(designation = nil, pattern_num = nil)
    base_root.patterns(designation, pattern_num)
  end
end