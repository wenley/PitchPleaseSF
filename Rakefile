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
  number_of_intervals = 10
  template = Musescore.parse_template_file
  intervals = Sequences.generate_intervals(number_of_intervals)

  Musescore.fill_intervals(intervals, template)

  Musescore.output_mscz_file(template, 'intervals.mscz')
  File.open('answer.txt', 'w') do |f|
    intervals.each_with_index do |interval, i|
      f.write("#{i + 1} = #{interval.type.serialize} over #{interval.base.serialize}\n")
    end
  end
  `#{MUSESCORE_LOCATION} -o ear_training.mp3 intervals.mscz`
end
