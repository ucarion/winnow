require 'spec_helper'

describe Winnow::Fingerprinter do
  describe '#initialize' do
    it 'accepts :guarantee_threshold, :noise_threshold' do
      fprinter = Winnow::Fingerprinter.new(
        guarantee_threshold: 0, noise_threshold: 1)
      expect(fprinter.guarantee_threshold).to eq 0
      expect(fprinter.noise_threshold).to eq 1
    end

    it 'accepts :t and :k' do
      fprinter = Winnow::Fingerprinter.new(t: 0, k: 1)
      expect(fprinter.guarantee_threshold).to eq 0
      expect(fprinter.noise_threshold).to eq 1
    end
  end

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
