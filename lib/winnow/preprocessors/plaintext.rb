module Winnow
  module Preprocessors
    class Plaintext < Preprocessor
      def preprocess(str)
        str.chars.each_with_index.to_a
      end
    end
  end
end
