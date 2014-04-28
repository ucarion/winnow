module Winnow
  class Fingerprinter
    attr_reader :guarantee, :noise
    alias_method :guarantee_threshold, :guarantee
    alias_method :noise_threshold, :noise

    def initialize(params)
      @guarantee = params[:guarantee_threshold] || params[:t]
      @noise = params[:noise_threshold] || params[:k]
    end
  end
end
