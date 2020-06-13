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
    def midi
      case self
      when G
        43
      when AFlat
        44
      when A
        45
      when BFlat
        46
      when B
        47
      when C
        48
      when CSharp
        49
      when D
        50
      when EFlat
        51
      when E
        52
      when F
        53
      when FSharp
        54
      else
        T.absurd(self)
      end
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
      case [base, type]
      when [Pitch::C, Type::MinorSecond]
        Pitch::CSharp.musescore_tone_pitch_class
      else
        0
      end
    end
  end
end
