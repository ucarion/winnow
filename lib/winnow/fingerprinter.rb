module Winnow
  class Fingerprinter
    attr_reader :guarantee, :noise
    alias_method :guarantee_threshold, :guarantee
    alias_method :noise_threshold, :noise

    def initialize(params)
      @guarantee = params[:guarantee_threshold] || params[:t]
      @noise = params[:noise_threshold] || params[:k]
    end

    def fingerprints(str)
      windows(str).reduce(Set.new) do |fingerprints, window|
        least_fingerprint = window.min_by { |fingerprint| fingerprint.value }

        fingerprints + [least_fingerprint]
      end
    end

    private

    def windows(str)
      k_grams(str).each_cons(window_size)
    end

    def window_size
      guarantee - noise + 1
    end

    def k_grams(str)
      current_line = 0
      current_col = 0

      str.chars.each_cons(noise).map do |k_gram|
        fingerprint = Fingerprint.new(k_gram.join.hash,
          Location.new(current_line, current_col))

        if k_gram.first == "\n"
          current_line += 1
          current_col = 0
        else
          current_col += 1
        end

        fingerprint
      end
    end
  end
end
