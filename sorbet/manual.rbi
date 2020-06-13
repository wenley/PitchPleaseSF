# typed: true

module RSpec
  sig { void }
  def describe; end
end

module Nokogiri
  module XML
  end

  sig { params(args: T.untyped).returns(XML) }
  def self.XML(*args); end
end
