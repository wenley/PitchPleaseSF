# frozen_string_literal: true

# typed: strong

require_relative './types'

module Sequences
  class << self
    extend T::Sig

    sig { params(number: Integer).returns(T::Array[Types::Interval]) }
    def generate_intervals(number)
      (1..number).map do
        Types::Interval.new(
          base: Types::Pitch.pick!,
          type: Types::Interval::Type.pick!
        )
      end
    end
  end
end
