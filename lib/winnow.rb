require 'winnow/version'
require 'winnow/fingerprinter'

module Winnow
  class Fingerprint < Struct.new(:value, :location)
  end

  class Location < Struct.new(:line, :column)
  end
end
