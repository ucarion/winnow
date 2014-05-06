module Winnow
  class Preprocessor
    def preprocess
      raise NotImplementedError
    end
  end
end

require 'winnow/preprocessors/plaintext_preprocessor'
