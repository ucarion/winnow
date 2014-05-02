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

      hashes = Set.new(('a'..'g').map(&:hash))
      fprint_hashes = Set.new(fprints.map(&:value))

      expect(fprint_hashes).to eq hashes
    end

    it 'chooses the smallest hash per window' do
      # window size = t - k + 1 = 2 ; for a two-char string, the sole
      # fingerprint should just be from the char with the smallest hash value
      fprinter = Winnow::Fingerprinter.new(t: 2, k: 1)
      fprints = fprinter.fingerprints("ab")

      expect(fprints.length).to eq 1
      expect(fprints.first.value).to eq ["a", "b"].map(&:hash).min
    end

    it 'correctly reports the location of a fingerprint' do
      fprinter = Winnow::Fingerprinter.new(t: 1, k: 1)
      fprints = fprinter.fingerprints("a\nb\ncde\nfg", source: "example")

      fprint_d = fprints.find { |fprint| fprint.value == "d".hash }

      expect(fprint_d.location.line).to eq 2
      expect(fprint_d.location.column).to eq 1
      expect(fprint_d.location.source).to eq "example"
    end
  end
end
