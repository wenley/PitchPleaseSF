task default: :run_all_specs

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
  Musescore.unpack_template!
  template = Musescore.load_template!
  intervals = Sequences.generate_intervals(number_of_intervals)

  # Musescore.fill_intervals(intervals, template)

  Musescore.output_mscz_file(template)
end
