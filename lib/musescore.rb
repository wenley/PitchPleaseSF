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

    sig { void }
    def reload_template
      @template ||= File.open('tmp/Ear_Training.mscx', 'r') do |f|
        Nokogiri::XML(f)
      end
    end
    attr_reader :template
  end
end
