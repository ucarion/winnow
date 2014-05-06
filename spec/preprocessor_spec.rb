require 'spec_helper'

describe Winnow::Preprocessors::PlaintextPreprocessor do
  subject { Winnow::Preprocessors::PlaintextPreprocessor.new }

  it 'converts a string to an array of chars and indices' do
    str = "abcde"
    char_indices = [['a', 0], ['b', 1], ['c', 2], ['d', 3], ['e', 4]]

    expect(subject.preprocess(str)).to eq char_indices
  end
end
