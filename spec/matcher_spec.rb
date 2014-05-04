require 'spec_helper'

describe Winnow::Matcher do
  describe '#find_matches' do
    fprint1 = {
      0 => [Winnow::Location.new(0, 0)],
      1 => [Winnow::Location.new(1, 1), Winnow::Location.new(2, 2)],
    }

    fprint2 = {
      0 => [Winnow::Location.new(3, 3)],
      1 => [Winnow::Location.new(4, 4)],
      3 => [Winnow::Location.new(5, 5)]
    }

    matches = Winnow::Matcher.find_matches(fprint1, fprint2)

    it 'returns a hash of match data' do
      expect(matches[0]).to be_a(Winnow::MatchDatum)
    end

    it 'reports a match when values are equal' do
      match = matches[0]

      matchloc_a = match.matches_from_a.first
      matchloc_b = match.matches_from_b.first

      expect(matchloc_a.line).to eq 0
      expect(matchloc_b.line).to eq 3
    end

    it 'reports nothing when there is no match' do
      match = matches[3]

      expect(match).to be_nil
    end

    it 'reports all matches when multi matches' do
      match = matches[1]

      expect(match.matches_from_a.length).to eq 2
      expect(match.matches_from_b.length).to eq 1
    end
  end
end
