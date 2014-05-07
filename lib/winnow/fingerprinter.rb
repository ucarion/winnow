module Winnow
  class Fingerprinter
    attr_reader :guarantee, :noise, :preprocessor
    alias_method :guarantee_threshold, :guarantee
    alias_method :noise_threshold, :noise

    def initialize(params)
      @guarantee = params[:guarantee_threshold] || params[:t]
      @noise = params[:noise_threshold] || params[:k]
      @preprocessor = params[:preprocessor] || Preprocessors::Plaintext.new
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
      tokens(str).each_cons(noise).map do |tokens_k_gram|
        value = tokens_k_gram.map { |(char, _)| char }.join.hash
        location = Location.new(source, tokens_k_gram.first[1])

        {value: value, location: location}
      end
    end

    def tokens(str)
      preprocessor.preprocess(str)
    end
  end
end
