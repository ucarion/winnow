module Winnow
  class Matcher
    class << self
      def find_matches(fingerprints_a, fingerprints_b)
        matched_values = fingerprints_a.keys & fingerprints_b.keys

        value_match_pairs = matched_values.map do |value|
          matches_a, matches_b = fingerprints_a[value], fingerprints_b[value]

          [value, MatchDatum.new(matches_a, matches_b)]
        end

        Hash[value_match_pairs]
      end
    end
  end
end
