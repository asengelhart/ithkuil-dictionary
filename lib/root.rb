require_relative './pattern'

class Root
  attr_reader :value, :translation, :derivations
  @@all = []

  def initialize(value, translation, derivations: nil)
    @value = value
    @translation = translation
    @patterned_after = patterned_after
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
  
end