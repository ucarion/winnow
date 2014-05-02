module Winnow
  class Matcher
    class << self
      def find_matches(fingerprints_a, fingerprints_b)
        values_a = value_to_fprint_map(fingerprints_a)
        values_b = value_to_fprint_map(fingerprints_b)

        shared_values = values_a.keys & values_b.keys

        shared_values.map do |value|
          matches_from_a = values_a[value]
          matches_from_b = values_b[value]

          MatchDatum.new(matches_from_a, matches_from_b)
        end
      end

      private

      def value_to_fprint_map(fingerprints)
        mapping = {}
        fingerprints.each do |fp|
          (mapping[fp.value] ||= []) << fp
        end
        mapping
      end
    end
  end
end
