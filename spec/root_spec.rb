require 'rspec'
require 'spec_helper'

RSpec.describe 'BasicRoot' do
  let!(:test_root) { BasicRoot.new('PK', 'EXPERIENCE / UNDERGO A STATE OR FEELING') }

  context "empty BasicRoot" do
    it 'has a phonetic value' do
      expect(test_root.value).to eq('PK')
    end

    it 'has a translation' do
      expect(test_root.translation).to eq('EXPERIENCE / UNDERGO A STATE OR FEELING')
    end

    it 'initializes with an empty hash-of-arrays' do
      expect(test_root.patterns.size).to eq(2)
      expect(test_root.patterns(:informal)).to eq([nil, nil, nil])
      expect(test_root.patterns(:formal)).to eq([nil, nil, nil])
    end


  end

  context "populated BasicRoot" do
    let!(:informal1) do 
      BasicPattern.new(:informal, 1, test_root, [
        'non-volitional (i.e., affective) experience of a state/feeling/emotion; feel (an) emotion [state + content]',
        'act or action caused by non-volitional experience of state or feeling',
        'cause or causal circumstance for non-volitional state/feeling'
     ])
    end
    let!(:informal2) do
      DerivedPattern.new(:informal, 2, informal1, 'w/ focus on process itself') 
    end 
    let!(:informal3) do
      DerivedPattern.new(:informal, 3, informal1, 'w/ focus on experiential state/feeling itself')
    end
    let!(:formal1) do
      DerivedPattern.new(:formal, 1, informal1, 
                         'except referring to a formal/institutionalized/symbolic '\
                         'expressions of the particular emotion.')
    end
    let!(:formal2) do
      DerivedPattern.new(:formal, 2, informal2, 
        'except referring to a formal/institutionalized/symbolic expressions ' \
        'of the particular emotion.')
    end
    let!(:formal3) do
      DerivedPattern.new(:formal, 3, informal3, 
        'except referring to a formal/institutionalized/symbolic expressions ' \
        'of the particular emotion.')
    end

    it 'has six Pattern objects' do
      expect(test_root.patterns(:informal, 1)).to eq(informal1)
      expect(test_root.patterns(:informal, 2)).to eq(informal2)
      expect(test_root.patterns(:informal, 3)).to eq(informal3)
      expect(test_root.patterns(:formal, 1)).to eq(formal1)
      expect(test_root.patterns(:formal, 2)).to eq(formal2)
      expect(test_root.patterns(:formal, 3)).to eq(formal3)
    end
  end

  context "DerivedRoot" do
    let(:derived_root) { DerivedRoot.new('-Ç-', 'excitement/thrill', test_root) }

    it 'has its own phonetic value' do
      expect(derived_root.value).to eq('-Ç-')
    end

    it 'has its own translation' do
      expect(derived_root.translation).to eq('excitement/thrill')
    end

    it 'has the same patterns and stems as its parent root' do
      expect(derived_root.patterns).to eq(test_root.patterns)
    end
  end
end
