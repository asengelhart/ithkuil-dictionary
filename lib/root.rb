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
    pattern_array = [pattern_or_array] if pattern_or_array.ancestors.include?(Pattern)
    pattern_array.each { |pattern| @patterns[pattern.designation][pattern.pattern_num] = pattern }
  end
end