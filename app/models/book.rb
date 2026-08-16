# frozen_string_literal: true

require "digest"

# A Book is not a record — it is an address plus the deterministic page
# derived from it. The entire library is the set of all finite hex strings,
# and no page is ever stored.
class Book
  DEFAULT_SHELF = "1"
  WALL = "wall1"
  SHELF = "shelf1"
  VOLUME = "volume1"
  SEARCH_WINDOW = 512
  SEARCH_LIMIT = 10

  attr_reader :hex

  def initialize(hex)
    @hex = BabelGenerator.sanitize(hex)
  end

  # "1.1.wall1.shelf1.volume1" — the original library's locator scheme.
  def address
    "#{hex}.#{DEFAULT_SHELF}.#{WALL}.#{SHELF}.#{VOLUME}"
  end

  def hex_short
    hex.length > 24 ? "#{hex[0, 12]}…#{hex[-12, 12]}" : hex
  end

  def page
    BabelGenerator.page(hex)
  end

  def previous
    Book.new(prev_hex)
  end

  def next
    Book.new(next_hex)
  end

  # Adjacency lives in hex space: +1 / -1 on the canonical address, with a
  # leading "1" so that going "back" from address 0 lands on address "0"
  # territory instead of wrapping into negative numbers.
  def next_hex
    (hex.to_i(16) + 1).to_s(16)
  end

  def prev_hex
    v = hex.to_i(16) - 1
    v.negative? ? DEFAULT_SHELF : v.to_s(16)
  end

  # Deterministic bounded phrase search, exactly like the original: walk
  # forward from this address, regenerate each page, and return the first
  # pages that contain the phrase. The window is bounded so a single query
  # cannot scan the whole (infinite) library.
  def search(phrase, window: SEARCH_WINDOW, limit: SEARCH_LIMIT)
    needle = phrase.to_s.strip
    return [] if needle.empty?

    found = []
    current = self
    window.times do
      break if found.length >= limit

      found << current if current.page.include?(needle)
      current = current.next
    end
    found
  end

  # One canonical, deterministic page that contains the given phrase: the
  # very first page at or after this address that does. Used by the search
  # flow so a hit always has a stable, shareable address.
  def self.first_containing(phrase, from: "0")
    new(from).search(phrase, limit: 1).first
  end

  def self.random
    entropy = SecureRandom.hex(12)
    # Occasionally start with a letter so the address space feels varied.
    entropy = "a#{entropy}" if rand > 0.5
    new(entropy)
  end
end
