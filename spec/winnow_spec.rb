require 'spec_helper'

describe Winnow::Fingerprinter do
  describe '#fingerprints' do
    it 'hashes strings to get keys' do
      # if t = k = 1, then each character will become a fingerprint
      fprinter = Winnow::Fingerprinter.new(t: 1, k: 1)
      fprints = fingerprinter.fingerprints("abcdefg")

      hashes = Set.new(('a'..'g').map(&:hash))
      fprint_hashes = Set.new(fprints.map(&:value))

      expect(fprint_hashes).to eq hashes
    end
  end
end
