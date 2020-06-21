# frozen_string_literal: true

# typed: strict

require_relative './types'

module Musescore
  TEMPLATE_ZIP_PATH = T.let('templates/Ear_Training.mscz', String)

  class << self
    extend T::Sig

    sig { params(filename: String).returns(Nokogiri::XML::Document) }
    def parse_template_file(filename: TEMPLATE_ZIP_PATH)
      `rm -rf tmp/`
      `mkdir -p tmp/`
      `unzip #{TEMPLATE_ZIP_PATH} -d tmp/`

      basename = File.basename(filename, '.*')
      parsed = File.open("tmp/#{basename}.mscx", 'r') do |f|
        Nokogiri::XML(f)
      end

      parsed
    end

    # Modify in-place for performance
    sig { params(interval_list: T::Array[Types::Interval], template: Nokogiri::XML::Document).void }
    def fill_intervals(interval_list, template)
      voices = template.css('Measure voice').to_a
      interval_to_insert = interval_list.zip([nil] * interval_list.count).flatten

      voices.zip(interval_to_insert).each do |voice_xml, interval|
        next if interval.nil?

        voice_children = voice_xml.children
        rest_node = voice_xml.at_css('Rest')
        if !rest_node.nil?
          voice_children.delete(rest_node)
        end

        chord_node = voice_children.at_css('Chord')
        if chord_node.nil?
          chord_node = Nokogiri::XML::Node.new('Chord', template)
          voice_children.push(chord_node)
        end
        duration_node = Nokogiri::XML::Node.new('durationType', template)
        duration_node.content = 'whole'
        chord_node.children = Nokogiri::XML::NodeSet.new(template, [
          duration_node,
          *interval_to_chord_xml_content(interval, template),
        ])
        voice_xml.children = voice_children
      end
    end

    sig { params(template: Nokogiri::XML::Document, filename: String).void }
    def output_mscz_file(template, filename)
      `rm -f intervals.mscz`
      `rm -rf output`
      `mkdir -p output`
      `cp -R tmp/ output/`
      File.open('output/Ear_Training.mscx', 'w') do |f|
        f << '<?xml version="1.0" encoding="UTF-8"?>'
        f << "\n"
        f << template.to_html
      end
      `cd output && zip -r ../#{filename} Ear_Training.mscx META-INF/container.xml Thumbnails/thumbnail.png`
    end

    sig { params(template: Nokogiri::XML::Document).returns(T::Array[String]) }
    def part_names(template)
      template.css('Instrument longName').map(&:content)
    end

    sig { params(template: Nokogiri::XML::Document).returns(Nokogiri::XML::Document) }
    def ensure_volume_and_pan_controls(template)
      template.css('Instrument Channel').each do |channel_node|
        if channel_node.at_css("controller[ctrl='7']")
          puts 'found volume'
        else
          puts 'no volume'
          volume_node = Nokogiri::XML::Node.new('controller', template)
          volume_node['ctrl'] = '7'
          volume_node['value'] = '99'
          channel_node.add_child(volume_node)
        end
        if channel_node.at_css("controller[ctrl='10']")
          puts 'found pan'
        else
          puts 'no pan'
          pan_node = Nokogiri::XML::Node.new('controller', template)
          pan_node['ctrl'] = '10'
          pan_node['value'] = '63'
          channel_node.add_child(pan_node)
        end
      end

      template
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
