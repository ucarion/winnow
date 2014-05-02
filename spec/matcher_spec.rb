require 'spec_helper'

describe Winnow::Matcher do
  describe '#find_matches' do
    fprint1 = [
      Winnow::Fingerprint.new(0, Winnow::Location.new(0, 0)),
      Winnow::Fingerprint.new(1, Winnow::Location.new(1, 1)),
      Winnow::Fingerprint.new(1, Winnow::Location.new(2, 2))
    ]

    fprint2 = [
      Winnow::Fingerprint.new(0, Winnow::Location.new(3, 3)),
      Winnow::Fingerprint.new(1, Winnow::Location.new(4, 4)),
      Winnow::Fingerprint.new(3, Winnow::Location.new(5, 5))
    ]

    matches = Winnow::Matcher.find_matches(fprint1, fprint2)

    it 'returns an array of match data' do
      expect(matches.first).to be_a(Winnow::MatchDatum)
    end

    it 'reports a match when values are equal' do
      match = matches.find do |match|
        match.matches_from_a.first.value == 0
      end

      matchloc_a = match.matches_from_a.first.location
      matchloc_b = match.matches_from_b.first.location

      expect(matchloc_a.line).to eq 0
      expect(matchloc_b.line).to eq 3
    end
  end
end
