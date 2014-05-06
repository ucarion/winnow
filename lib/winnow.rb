require 'winnow/version'
require 'winnow/preprocessor'
require 'winnow/fingerprinter'
require 'winnow/matcher'

module Winnow
  class Location < Struct.new(:source, :index)
  end

  class MatchDatum < Struct.new(:matches_from_a, :matches_from_b)
  end
end
