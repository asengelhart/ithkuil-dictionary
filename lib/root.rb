require_relative './pattern'
class Root
  attr_reader :value, :translation, :derivations
  @@all = []

  def initialize(value, translation, patterns: nil, patterned_after: nil, derivations: nil)
    @value = value
    @translation = translation
    @patterns = patterns
    @patterned_after = patterned_after
    @derivations = derivations
    raise PatternNumberError unless @patterns ^ @patterned_after
    if @patterns
      raise InvalidPatternError unless @patterns.size == 6
    end
  end

  class PatternNumberError < StandardError
    def message
      'Roots must be initialized with either a :pattern or a :patterned_after argument'
    end
  end

  class InvalidPatternError < StandardError
    def message
      ':pattern must contain a valid Pattern object.'
    end
  end
end
