module Winnow
  class Fingerprinter
    attr_reader :guarantee, :noise
    alias_method :guarantee_threshold, :guarantee
    alias_method :noise_threshold, :noise

    def initialize(params)
      @guarantee = params[:guarantee_threshold] || params[:t]
      @noise = params[:noise_threshold] || params[:k]
    end

    def fingerprints(str, params = {})
      source = params[:source]

      fingerprints = {}

      windows(str, source).each do |window|
        least_fingerprint = window.min_by { |fingerprint| fingerprint[:value] }
        value = least_fingerprint[:value]
        location = least_fingerprint[:location]

        (fingerprints[value] ||= []) << location
      end

      fingerprints
    end

    private

    def windows(str, source)
      k_grams(str, source).each_cons(window_size)
    end

    def window_size
      guarantee - noise + 1
    end

    def k_grams(str, source)
      str.chars.each_cons(noise).each_with_index.map do |k_gram, index|
        location = Location.new(source, index)
        {value: k_gram.join.hash, location: location}
      end
    end
  end
end
