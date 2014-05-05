module Winnow
  class Matcher
    class << self
      def find_matches(fingerprints_a, fingerprints_b, params = {})
        whitelist = params[:whitelist] || []

        matched_values = fingerprints_a.keys & fingerprints_b.keys - whitelist

        matched_values.map do |value|
          matches_a, matches_b = fingerprints_a[value], fingerprints_b[value]
          MatchDatum.new(matches_a, matches_b)
        end
      end
    end
  end
end
