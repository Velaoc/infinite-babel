# frozen_string_literal: true

require "digest"

# Deterministic infinite library, in the spirit of libraryofbabel.info.
#
# A book's page — 4100 characters of lowercase letters, spaces, and the
# occasional comma or period — is a pure function of its hex address.
# Nothing is ever stored: the address is the only datum, and the same
# address yields the same page on every machine, forever.
class BabelGenerator
  ALPHABET = ("a".."z").to_a.freeze
  PAGE_LENGTH = 4100
  LINES = 41
  LINE_LENGTH = 100
  MAX_WORD = 10

  attr_reader :hex

  def self.page(hex)
    new(hex).page
  end

  # "0" is the canonical address of the first book. Anything that is not a
  # hex digit is stripped; a blank address means the first book.
  def self.sanitize(value)
    value.to_s.downcase.gsub(/[^0-9a-f]/, "").presence || "0"
  end

  def initialize(hex)
    @hex = self.class.sanitize(hex)
  end

  # The canonical page: exactly PAGE_LENGTH characters, laid out as
  # LINES x LINE_LENGTH. When read as prose the line structure is
  # invisible; the length is what matters.
  def page
    @page ||= begin
      rng = SplitMix64.new(Digest::SHA256.hexdigest(hex).to_i(16))
      words = []
      words << next_word(rng) while words.join(" ").length < PAGE_LENGTH
      words.join(" ")[0, PAGE_LENGTH].ljust(PAGE_LENGTH)
    end
  end

  def words
    page.split
  end

  private

  def next_word(rng)
    len = 1 + (rng.next % MAX_WORD)
    word = +""
    len.times { word << ALPHABET[rng.next % 26] }
    # Rare punctuation, the way the original library's orthography has it.
    word << (rng.next.odd? ? "." : ",") if (rng.next % 27).zero?
    word
  end

  # splitmix64: small, fast, good-enough determinism for a reading library.
  # Seeded from the address, so neighbors are unrelated pages.
  class SplitMix64
    MASK = 0xFFFF_FFFF_FFFF_FFFF

    def initialize(seed)
      @state = seed & MASK
    end

    def next
      @state = (@state + 0x9E37_79B9_7F4A_7C15) & MASK
      z = @state
      z = ((z ^ (z >> 30)) * 0xBF58_476D_1CE4_E5B9) & MASK
      z = ((z ^ (z >> 27)) * 0x94D0_49BB_1331_11EB) & MASK
      z ^ (z >> 31)
    end
  end
end
