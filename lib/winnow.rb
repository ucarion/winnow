require 'winnow/version'
require 'winnow/fingerprinter'
require 'winnow/matcher'

module Winnow
  class Location < Struct.new(:source, :line, :column)
  end

  class MatchDatum < Struct.new(:matches_from_a, :matches_from_b)
  end
end
