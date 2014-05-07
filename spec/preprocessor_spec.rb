require 'spec_helper'

describe Winnow::Preprocessors::PlaintextPreprocessor do
  subject { Winnow::Preprocessors::PlaintextPreprocessor.new }

  it 'converts a string to an array of chars and indices' do
    str = "abcde"
    char_indices = [['a', 0], ['b', 1], ['c', 2], ['d', 3], ['e', 4]]

    expect(subject.preprocess(str)).to eq char_indices
  end
end

describe Winnow::Preprocessors::SourceCodePreprocessor do
  subject { Winnow::Preprocessors::SourceCodePreprocessor.new(:java) }

  it 'simplifies a string, but remembers correct locations' do
    str = "i = 5"
    result = [['x', 0], ['=', 2], ['5', 4]]

    expect(subject.preprocess(str)).to eq result
  end

  it 'groups up the indices of a single token' do
    str = "int i"
    result = [['i', 0], ['n', 0], ['t', 0], ['x', 4]]

    expect(subject.preprocess(str)).to eq result
  end

  def reconstruct_string(processed)
    processed.map { |(char, _)| char }.join
  end

  it 'removes whitespace' do
    str = '3;    '
    expect(reconstruct_string(subject.preprocess(str))).to eq '3;'
  end

  it 'removes variable names' do
    str = 'class MyClass { int myInteger = 5 }'
    expect(reconstruct_string(subject.preprocess(str))).to eq 'classx{intx=5}'
  end

  it 'removes comments' do
    str = 'fooBar();//this is a comment'
    expect(reconstruct_string(subject.preprocess(str))).to eq 'x();'
  end
end
