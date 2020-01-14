require 'rspec'
require 'spec_helper'

RSpec.describe 'Pattern' do
  let!(:test_root) { BasicRoot.new('PK', 'EXPERIENCE / UNDERGO A STATE OR FEELING') }
  let!(:informal1) do 
    BasicPattern.new(:informal, 1, test_root, [
      'non-volitional (i.e., affective) experience of a state/feeling/emotion; feel (an) emotion [state + content]',
      'act or action caused by non-volitional experience of state or feeling',
      'cause or causal circumstance for non-volitional state/feeling'
   ])
  end
  let!(:informal2) do
    DerivedPattern.new(:informal, 2, :informal1, 'w/ focus on process itself') 
  end
  let!(:informal3) do
    DerivedPattern.new(:informal, 3, :informal1, 'w/ focus on experiential state/feeling itself')
  end
  let!(:formal1) do
    DerivedPattern.new(:formal, 1, :informal1, 
                       'except referring to a formal/institutionalized/symbolic '\
                       'expressions of the particular emotion.')
  end
  let!(:formal2) do
    DerivedPattern.new(:formal, 2, :informal2, 
      'except referring to a formal/institutionalized/symbolic expressions ' \
      'of the particular emotion.')
  end
  let!(:formal3) do
    DerivedPattern.new(:formal, 3, :informal3, 
      'except referring to a formal/institutionalized/symbolic expressions ' \
      'of the particular emotion.')
  end

  context "BasicPattern" do
    it "has a designation" do
      expect(informal1.designation).to eq(:informal)
    end

    it "has a number" do
      expect(informal1.pattern_num).to eq(1)
    end

    it "is associated with a root" do
      expect(informal1.pattern_num).to eq(test_root)
    end
  end
end
