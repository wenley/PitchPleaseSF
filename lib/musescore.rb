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
    def fill_intervals(interval_list, template)
      template.css('Measure voice').each do |voice|
        chord = voice.at_css('Chord')
        chord.content = <<-XML
          <durationType>whole</durationType>
          <Note>
            <pitch>
        XML
      end
    end

    sig { params(template: Nokogiri::XML).void }
    def output_mscz_file(template)
      `rm -rf output`
      `cp tmp/* output/`
      File.open('output/Ear_Training.mscx', 'w') do |f|
        f << template.to_html
      end
    end

    private

    sig { params(interval: Types::Interval).returns(String) }
    def interval_to_chord_xml_content(interval)
      <<-XML
        <Note>
          <pitch>#{interval.base_midi_pitch}</pitch>
          <tpc>#{interval.base_musescore_tone_pitch_class}</tpc>
        </Note>
        <Note>
          <pitch>#{interval.top_midi_pitch}</pitch>
          <tpc>#{interval.top_musescore_tone_pitch_class}</tpc>
        </Note>
      XML
    end
  end
end
