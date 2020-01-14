require 'spec_helper'

describe 'Root' do
  let(:test_root) { Root.new('PK', 'EXPERIENCE / UNDERGO A STATE OR FEELING') }
  let(:pattern_array) do
    [
      Pattern.new(test_root, :informal, 1, [
        'non-volitional (i.e., affective) experience of a state/feeling/emotion; feel (an) emotion [state + content]',
        'act or action caused by non-volitional experience of state or feeling',
        'cause or causal circumstance for non-volitional state/feeling'
      ]),
      Pattern.new(test_root, :informal, 2, [
        'non-volitional (i.e., affective) experience of a state/feeling/emotion; feel (an) emotion [state + content], ' \
        'w/ focus on process itself',
        
      ])
    ]
  end
end
