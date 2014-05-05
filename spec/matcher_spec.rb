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

    let(:matches) { Winnow::Matcher.find_matches(fprint1, fprint2) }

    def match_with_loc(line_number, matches = matches)
      matches.find do |data|
        data.matches_from_a.find { |loc| loc.line == line_number } ||
          data.matches_from_b.find { |loc| loc.line == line_number }
      end
    end

    it 'returns an array of match data' do
      expect(matches).to be_an(Array)
      expect(matches.first).to be_a(Winnow::MatchDatum)
    end

    it 'reports a match when values are equal' do
      match = match_with_loc(0)
      matchloc_b = match.matches_from_b.first
      expect(matchloc_b.line).to eq 3
    end

    it 'reports nothing when there is no match' do
      match = match_with_loc(5)
      expect(match).to be_nil
    end

    it 'reports all matches when multi matches' do
      match = match_with_loc(1)
      expect(match.matches_from_a.length).to eq 2
      expect(match.matches_from_b.length).to eq 1
    end

    it 'ignores whitelisted values' do
      matches = Winnow::Matcher.find_matches(fprint1, fprint2, whitelist: [0])

      expect(match_with_loc(0, matches)).to be_nil
    end
  end
end
