require 'rouge'

module Winnow
  module Preprocessors
    class SourceCode < Preprocessor
      attr_reader :lexer

      def initialize(language)
        @lexer = Rouge::Lexer.find(language)
      end

      def preprocess(str)
        current_index = 0
        processed_chars = []

        lexer.lex(str).to_a.each do |token|
          type, chunk = token

          processed_chunk = case
          when type <= Rouge::Token::Tokens::Name
            'x'
          when type <= Rouge::Token::Tokens::Comment
            ''
          when type <= Rouge::Token::Tokens::Text
            ''
          else
            chunk
          end

          processed_chars += processed_chunk.chars.map do |c|
            [c, current_index]
          end

          current_index += chunk.length
        end

        processed_chars
      end
    end
  end
end
