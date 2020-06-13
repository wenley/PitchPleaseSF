# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sequences do
  describe '.generate_intervals' do
    subject { described_class.generate_intervals(number) }
    let(:number) { 10 }

    it { expect(subject.count).to eq(number) }
  end
end
