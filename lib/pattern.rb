require_relative './root'
require 'pry'

class Pattern
  attr_reader :designation, :pattern_num

  def initialize(designation, pattern_num)
    raise DesignationError unless [:formal, :informal].include?(designation)
    raise PatternNumError unless (1..3).include?(pattern_num)

    @designation = designation
    @pattern_num = pattern_num
  end

  class DesignationError < StandardError
    def message
      'Designation must be either :formal or :informal'
    end
  end

  class PatternNumError < StandardError
    def message
      'Pattern number must be 1, 2 or 3'
    end
  end
end

class BasicPattern < Pattern
  attr_reader :root

  def initialize(designation, pattern_num, root, stems)
    raise StemError unless stems.size == 3

    super(designation, pattern_num)
    @stems = stems
    @root = root
    #binding.pry
    @root.add_patterns(self)
  end

  def stems(index = nil)
    index ? @stems[index] : @stems
  end

  class StemError < StandardError
    def message
      'Stems must be an array of size == 3'
    end
  end
end

class DerivedPattern < Pattern
  attr_reader :base_pattern, :suffix
  def initialize(designation, pattern_num, base_pattern, suffix)
    super(designation, pattern_num)
    @base_pattern = base_pattern
    @suffix = suffix
  end

end