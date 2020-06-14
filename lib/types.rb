# frozen_string_literal: true

# typed: strict

module Types
  class Pitch < T::Enum
    extend T::Sig

    enums do
      C = new
      CSharp = new
      D = new
      EFlat = new
      E = new
      F = new
      FSharp = new
      G = new
      AFlat = new
      A = new
      BFlat = new
      B = new
    end

    sig { returns(Pitch) }
    def self.pick!
      item = T.must(values.sample)
      raise 'Unexpected' if item.is_a?(Array)

      item
    end

    sig { returns(Integer) }
    def offset_from_g
      T.must(PITCH_TO_OFFSETS[self])
    end

    sig { params(number_of_half_steps: Integer).returns(Pitch) }
    def raise_by_half_steps(number_of_half_steps)
      T.must(OFFSET_TO_PITCH[(offset_from_g + number_of_half_steps) % 12])
    end

    sig { params(offset: Integer).returns(Integer) }
    def midi(offset: 0)
      offset_from_g + 55 + (offset * 12)
    end

    sig { returns(Integer) }
    def musescore_tone_pitch_class
      # Organized by Circle of Fifths
      case self
      when AFlat
        10
      when EFlat
        11
      when BFlat
        12
      when F
        13
      when C
        14
      when G
        15
      when D
        16
      when A
        17
      when E
        18
      when B
        19
      when FSharp
        20
      when CSharp
        21
      else
        T.absurd(self)
      end
    end
  end

  PITCH_TO_OFFSETS = T.let(
    {
      Pitch::G => 0,
      Pitch::AFlat => 1,
      Pitch::A => 2,
      Pitch::BFlat => 3,
      Pitch::B => 4,
      Pitch::C => 5,
      Pitch::CSharp => 6,
      Pitch::D => 7,
      Pitch::EFlat => 8,
      Pitch::E => 9,
      Pitch::F => 10,
      Pitch::FSharp => 11,
    },
    T::Hash[Pitch, Integer],
  )
  OFFSET_TO_PITCH = T.let(
    PITCH_TO_OFFSETS.invert,
    T::Hash[Integer, Pitch],
  )

  class SevenChord < T::Struct
    class Type < T::Enum
      enums do
        Major = new
        Dominant = new
        Minor = new
        HalfDiminished = new
        Diminshed = new
        Augmented = new
      end
    end

    const :tonic, Pitch
    const :type, Type
  end

  class Triad < T::Struct
    class Type < T::Enum
      enums do
        Major = new
        Minor = new
        Diminshed = new
        Augmented = new
      end
    end

    const :tonic, Pitch
    const :type, Type
  end

  class Interval < T::Struct
    extend T::Sig

    class Type < T::Enum
      extend T::Sig

      enums do
        MinorSecond = new
        MajorSecond = new
        MinorThird = new
        MajorThird = new
        Fourth = new
        Fifth = new
        MinorSixth = new
        MajorSixth = new
        MinorSeventh = new
        MajorSeventh = new
        Octave = new
      end

      sig { returns(Type) }
      def self.pick!
        item = T.must(values.sample)
        raise 'Unexpected' if item.is_a?(Array)

        item
      end

      sig { returns(Integer) }
      def half_steps
        case self
        when MinorSecond
          1
        when MajorSecond
          2
        when MinorThird
          3
        when MajorThird
          4
        when Fourth
          5
        when Fifth
          7
        when MinorSixth
          8
        when MajorSixth
          9
        when MinorSeventh
          10
        when MajorSeventh
          11
        when Octave
          12
        else
          T.absurd(self)
        end
      end
    end

    const :base, Pitch
    const :type, Type

    sig { returns(Integer) }
    def base_midi_pitch
      base.midi
    end

    sig { returns(Integer) }
    def base_musescore_tone_pitch_class
      base.musescore_tone_pitch_class
    end

    sig { returns(Integer) }
    def top_midi_pitch
      base_midi_pitch + type.half_steps
    end

    sig { returns(Integer) }
    def top_musescore_tone_pitch_class
      base.raise_by_half_steps(type.half_steps).musescore_tone_pitch_class
    end
  end
end
