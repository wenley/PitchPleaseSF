task default: :run_all_specs

MUSESCORE_LOCATION = '~/Applications/MuseScore3.app/Contents/MacOS/mscore'

task :environment do
  require 'bundler/setup'
  Bundler.require(:default)
  require_relative './lib/ear_training'
end

task(rspec: :environment) do
  RSpec::Core::Runner.run(['spec'], STDERR, STDOUT)
end

task :rubocop do
  `bundle exec rubocop`
end

task :sorbet do
  `bundle exec srb typecheck`
end

task(run_all_specs: [:sorbet, :rspec, :rubocop]) do
end

task(make_interval_test: :environment) do
  `mkdir -p output/ear_training/`
  number_of_intervals = 10
  template = Musescore.parse_template_file
  intervals = Sequences.generate_intervals(number_of_intervals)

  Musescore.fill_intervals(intervals, template)

  Musescore.output_mscz_file(template, 'output/ear_training/intervals.mscz')
  File.open('output/ear_training/answer.txt', 'w') do |f|
    intervals.each_with_index do |interval, i|
      f.write("#{i + 1} = #{interval.type.serialize} over #{interval.base.serialize}\n")
    end
  end
  `#{MUSESCORE_LOCATION} -o ear_training.mp3 output/ear_training/intervals.mscz`
  `mv ear_training.mp3 output/ear_training`
end

task(:make_learning_tracks, [:musescore_filename] => [:environment]) do |task, args|
  input_filename = args[:musescore_filename]
  basename = File.basename(input_filename, '.*')
  output_dir = "output/#{basename}"
  `mkdir -p #{output_dir}`

  template = Musescore.parse_template_file(filename: input_filename)
  template = Musescore.ensure_volume_and_pan_controls(template)

  puts "Prepped XML template. Making MP3s..."

  template.css('Part Instrument').each do |main_instrument_node|
    main_part_name = main_instrument_node.at_css('longName').content
    puts "Making mp3 for #{main_part_name}..."

    template.css('Part Instrument').each do |instrument_node|
      part_name = instrument_node.at_css('longName').content

      if main_part_name == part_name
        # Loud volume
        instrument_node.at_css("controller[ctrl='7']")['value'] = '105'
        # Pan right
        instrument_node.at_css("controller[ctrl='10']")['value'] = '120'
      else
        # Soft volume
        instrument_node.at_css("controller[ctrl='7']")['value'] = '40'
        # Pan left
        instrument_node.at_css("controller[ctrl='10']")['value'] = '20'
      end
    end

    Musescore.output_mscz_file(template, 'tmp/test.mscz')

    `#{MUSESCORE_LOCATION} -o #{main_part_name}.mp3 tmp/test.mscz`
    `mv #{main_part_name}.mp3 #{output_dir}/`
  end
end

task(:make_pdf, [:musescore_filename] => [:environment]) do |task, args|
  input_filename = args[:musescore_filename]
  basename = File.basename(input_filename, '.*')
  output_dir = "output/#{basename}"

  `#{MUSESCORE_LOCATION} -o #{basename}.pdf #{input_filename}`
  `mv #{basename}.pdf #{output_dir}/`
end
