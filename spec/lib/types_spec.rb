# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Types do
  describe 'Pitch.pick!' do
    subject { Types::Pitch.pick! }

    it { expect { subject }.to_not raise_error }
  end

  describe 'Interval::Type.pick!' do
    subject { Types::Interval::Type.pick! }

    it { expect { subject }.to_not raise_error }
  end
end
