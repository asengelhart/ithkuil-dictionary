require_relative './pattern'

class Root
  attr_reader :value, :translation, :derivations
  @@all = []

  def initialize(value, translation, derivations: nil)
    @value = value
    @translation = translation
    if @patterned_after.nil?
      @patterns = { informal: Array.new(3), formal: Array.new(3) }
    else
      @patterns = nil
    end
    @derivations = derivations
    @@all << self
  end
end

class BasicRoot < Root
  def add_patterns(pattern_or_array)
    pattern_array = [pattern_or_array] unless pattern_or_array.class == Array
    pattern_array.each do |pattern| 
      @patterns[pattern.designation][pattern.pattern_num - 1] = pattern
    end
  end
end