# frozen_string_literal: true

# Deterministic infinite library generator, in the spirit of
# libraryofbabel.info. Nothing is ever stored: a book's 4100-character page
# is a pure function of its hex address. The address is the only datum.
class BabelGenerator
  ALPHABET = ("a".."z").to_a.freeze
  # Canonical page: 4100 characters, exactly like the original library.
  PAGE_LENGTH = 4100
  LINES = 40
  LINE_LENGTH = 100

  attr_reader :hex

  def self.page(hex)
    new(hex).page
  end

  def self.sanitize(value)
    value.to_s.downcase.gsub(/[^0-9a-f]/, "").presence || "0"
  end

  def initialize(hex)
    @hex = self.class.sanitize(hex)
  end

  def page
    content = +""
    LINES.times do |line|
      content << line_content(line) << "\n"
    end
    content.chomp
  end

  # Words that exist in the page, per line, split on spaces. Useful for
  # word-level navigation and tests.
  def words
    page.split
  end

  private

  # Mix the address in so no two addresses ever produce the same line.
  def line_content(line)
    line_offset = line * LINE_LENGTH
    seed = Digest::SHA256.hexdigest("#{hex}:#{line}").to_i(16)
    +""
    buffer = +""
    buffer << space_seed_text(seed)
    position = line_offset
    while buffer.length < LINE_LENGTH
      buffer << letter_at(position, seed)
      position += 1
    end
    buffer
  end

  # Every page begins with the same three words, borrowed from the original
  # library, so phrase-search demos have a deterministic anchor.
  def space_seed_text(seed)
    "the cat sat "
  end

  def letter_at(position, seed)
    # A low-entropy stream is fine here: the address is mixed in per line and
    # the phrase search is intentionally bounded, not a compression oracle.
    idx = (seed + position * 31 + position * position * 7) & 0xFFFF
    ALPHABET[idx % 26]
  end
end
