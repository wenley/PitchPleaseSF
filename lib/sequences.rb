# typed: strong

require_relative './types'

module Sequences
  class << self
    extend T::Sig

    sig { params(n: Integer).returns(T::Array[Types::Interval]) }
    def generate_intervals(n)
      (1..n).map do
        Types::Interval.new(
          base: Types::Pitch.pick!,
          type: Types::Interval::Type.pick!,
        )
      end
    end
  end
end
