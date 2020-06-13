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

    sig { returns(Nokogiri::XML::Document) }
    def load_template!
      File.open('tmp/Ear_Training.mscx', 'r') do |f|
        Nokogiri::XML(f)
      end
    end

    # Modify in-place for performance
    sig { params(interval_list: T::Array[Types::Interval], template: Nokogiri::XML::Document).void }
    def fill_intervals(interval_list, template)
      voices = template.css('Measure voice').to_a
      interval_to_insert = interval_list.zip([nil] * interval_list.count).flatten

      voices.zip(interval_to_insert).each do |voice_xml, interval|
        next if interval.nil?

        chord_node = voice_xml.at_css('Chord')
        if chord_node.nil?
          chord_node = Nokogiri::XML::Node.new('Chord', template)
          chord_node.parent = voice_xml
        end
        duration_node = Nokogiri::XML::Node.new('durationType', template)
        duration_node.content = 'whole'
        chord_node.children = Nokogiri::XML::NodeSet.new(template, [
          duration_node,
          *interval_to_chord_xml_content(interval, template),
        ])
      end
    end

    sig { params(template: Nokogiri::XML::Document).void }
    def output_mscz_file(template)
      `rm -f intervals.mscz`
      `rm -rf output`
      `mkdir -p output`
      `cp -R tmp/ output/`
      File.open('output/Ear_Training.mscx', 'w') do |f|
        f << '<?xml version="1.0" encoding="UTF-8"?>'
        f << "\n"
        f << template.to_html
      end
      `cd output && zip -r ../intervals.mscz Ear_Training.mscx META-INF/container.xml Thumbnails/thumbnail.png`
    end

    private

    sig { params(interval: Types::Interval, document: Nokogiri::XML::Document).returns(T::Array[Nokogiri::XML::Node]) }
    def interval_to_chord_xml_content(interval, document)
      base_note = Nokogiri::XML::Node.new('Note', document)
      pitch_node = Nokogiri::XML::Node.new('pitch', document)
      pitch_node.content = "#{interval.base_midi_pitch}"
      base_note.add_child(pitch_node)
      tpc_node = Nokogiri::XML::Node.new('tpc', document)
      tpc_node.content = "#{interval.base_musescore_tone_pitch_class}"
      base_note.add_child(tpc_node)

      top_note = Nokogiri::XML::Node.new('Note', document)
      pitch_node = Nokogiri::XML::Node.new('pitch', document)
      pitch_node.content = "#{interval.top_midi_pitch}"
      top_note.add_child(pitch_node)
      tpc_node = Nokogiri::XML::Node.new('tpc', document)
      tpc_node.content = "#{interval.top_musescore_tone_pitch_class}"
      top_note.add_child(tpc_node)

      [base_note, top_note]
    end
  end
end
