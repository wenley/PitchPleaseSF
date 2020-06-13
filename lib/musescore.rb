# frozen_string_literal: true

# typed: strict

require_relative './types'

module Musescore
  TEMPLATE_ZIP_PATH = T.let('Ear_Training.mscz', String)

  class << self
    extend T::Sig

    sig { void }
    def unpack_template!
      `rm -rf tmp/`
      `mkdir -p tmp/`
      `unzip #{TEMPLATE_ZIP_PATH} -d tmp/`
    end

    sig { returns(Nokogiri::XML) }
    def load_template!
      File.open('tmp/Ear_Training.mscx', 'r') do |f|
        Nokogiri::XML(f)
      end
    end

    # Modify in-place for performance
    sig { params(interval_list: T::Array[Types::Interval], template: Nokogiri::XML).void }
    def fill_intervals(interval_list, template); end
  end
end
