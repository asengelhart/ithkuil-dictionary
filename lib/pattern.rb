require_relative './pattern'

class Pattern
  attr_reader :root, :designation

  def initialize(root, designation, stems)
    @root = root
    @designation = designation
    raise DesignationError unless [:formal, :informal].include?(@designation)
    @stems = stems
    raise StemError unless @stems.size == 3
  end

  def stems(index = nil)
    if index
      @stems[index]
    else
      @stems
    end
  end

  class DesignationError < StandardError
    def message
      'Designation must be either :formal or :informal'
    end
  end

  class StemError < StandardError
    def message
      'Stems must be an array of size == 3'
    end
  end
end