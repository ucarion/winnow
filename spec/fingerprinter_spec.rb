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
      fprints = fprinter.fingerprints("abcdefg")

      hashes = ('a'..'g').map(&:hash)

      expect(fprints.keys).to eq hashes
    end

    it 'chooses the smallest hash per window' do
      # window size = t - k + 1 = 2 ; for a two-char string, the sole
      # fingerprint should just be from the char with the smallest hash value
      fprinter = Winnow::Fingerprinter.new(t: 2, k: 1)
      fprints = fprinter.fingerprints("ab")

      expect(fprints.keys.length).to eq 1
      expect(fprints.keys.first).to eq ["a", "b"].map(&:hash).min
    end

    it 'correctly reports the location of a fingerprint' do
      fprinter = Winnow::Fingerprinter.new(t: 1, k: 1)
      fprints = fprinter.fingerprints("a\nb\ncde\nfg", source: "example")

      fprint_d = fprints['d'.hash].first

      expect(fprint_d.index).to eq 5
      expect(fprint_d.source).to eq "example"
    end
  end
end
