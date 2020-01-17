require 'rspec'
require 'spec_helper'

RSpec.describe 'Scraper' do
  let!(:test_root) do 
    BasicRoot.new('LB', 'DIMENSIONAL/SPATIO-TEMPORAL RELATIONS', <<-NOTEPARAM
      The stems of this root are commonly used with the SUF, EXD, FLC, PTW and Intensity affixes. 
      EXAMPLE MORPHOLOGICAL DERIVATIVES FROM THE ABOVE STEMS: big/large, small/little, shrink, expand, grow, diminish, huge, immense, tiny, enormous, shallow
    NOTEPARAM
    )
  end
  let!(:informal1) do
    BasicPattern.new(:informal, 1, test_root, [
      'degree of (static) dimensional property (e.g., short/long)',
      'dynamic decrease in degree of dimensional property (e.g., shorten/ing)',
      'dynamic increase in degree of dimensional property (e.g., lengthen/ing)'
    ])
  end
  let(:informal2) { DerivedPattern.new(:informal, 2, informal1, 'applied to spatial context')}
  let(:informal3) { DerivedPattern.new(:informal, 3, informal1, 'applied to temporal context')}
  let(:formal1) do DerivedPattern.new(:formal, 1, informal1, 
    'but in reference to an applied contextual gestalt (e.g., the vicinity, the depths, the expanse, the interregnum, the surroundings, the perimeter, etc.)')
  end 
  let(:formal2) do DerivedPattern.new(:formal, 2, informal2, 
    'but in reference to an applied contextual gestalt (e.g., the vicinity, the depths, the expanse, the interregnum, the surroundings, the perimeter, etc.)')
  end 
  let(:formal3) do DerivedPattern.new(:formal, 3, informal3, 
    'but in reference to an applied contextual gestalt (e.g., the vicinity, the depths, the expanse, the interregnum, the surroundings, the perimeter, etc.)')
  end

  let!(:derived_root) { DerivedRoot.new('LC', 'PROXIMITY/DISTANCE', test_root) }

  describe '#search_translation' do
    it 'includes a basic root object when translation param matches a basic root' do
      result = Scraper.search_translation("spatio-temporal")
      expect(result.include?{ |item| item.is_a?(BasicRoot) })
    end
    it 'includes correct value, translation, and stems for basic roots'
      expect(result.include?{ |item| item.value == test_root.value }
      expect(result.include?{ |item| item.translation == test_root.translation }
      expect(result.include?{ |item| item.stems == test_root.stems })
    end
  end
end