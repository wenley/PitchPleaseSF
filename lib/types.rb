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
    end

    const :base, Pitch
    const :type, Type
  end
end
