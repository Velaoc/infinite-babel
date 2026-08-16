# frozen_string_literal: true

require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "address includes shelf, wall, shelf, and volume" do
    book = Book.new("1")
    assert_equal "1.1.wall1.shelf1.volume1", book.address
  end

  test "page is deterministic and comes from the generator" do
    assert_equal BabelGenerator.page("abc"), Book.new("abc").page
  end

  test "vault books embed recovered text" do
    assert_includes Book.new("2").page, "sphere whose exact center"
  end

  test "adjacency walks hex space in both directions" do
    assert_equal "2", Book.new("1").next.hex
    assert_equal "0", Book.new("1").previous.hex
    # Going before the first book stays in the first book's territory.
    assert_equal "1", Book.new("0").previous.hex
  end

  test "search finds a phrase deterministically within the window" do
    hit = Book.first_containing("In the infinite library")
    assert hit
    assert_includes hit.page, "In the infinite library"
  end

  test "search window is bounded" do
    start = Book.new("f" * 24)
    results = start.search("zzzzzzzzzzzzzzzz", window: 64, limit: 1)
    assert_empty results
  end
end
