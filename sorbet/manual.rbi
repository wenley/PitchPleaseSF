# typed: true

module RSpec
  sig { void }
  def describe; end
end

module Nokogiri
  module XML
    class Document
      sig { params(selector: String).returns(T.untyped) }
      def css(selector); end

      sig { returns(String) }
      def to_html; end
    end
  end

  sig { params(args: T.untyped).returns(XML) }
  def self.XML(*args); end
end
