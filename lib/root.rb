require_relative './pattern'
require 'pry'
class Root
  attr_reader :value
  @@all = []

  def initialize(value, translation)
    @value = value
    @translation = translation
    @@all << self
  end

  def translation
    @translation.downcase
  end
end

class BasicRoot < Root
  attr_accessor :notes

  def initialize(value, translation, notes = nil)
    super(value, translation)
    @notes = notes
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

  def search(param)
    translation.include?(param) || notes.include?(param) ? self : search_patterns(param)
  end

  def search_patterns(param)
    results = [self]
    patterns.each do |designation, pattern_array|
      pattern_array.each_with_index do |pattern, pattern_index|
        pattern.stems.each_with_index { |stem, stem_index| results << [designation, pattern_index + 1, stem_index + 1] if stem.include?(param) }
      end
    end
    results.size > 1 ? results : nil
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

  def search(param)
    translation.include?(param) ? self : nil
  end
end