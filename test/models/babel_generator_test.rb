# frozen_string_literal: true

require "test_helper"

class BabelGeneratorTest < ActiveSupport::TestCase
  test "page is exactly 4100 characters" do
    assert_equal 4100, BabelGenerator.page("1").length
    assert_equal 4100, BabelGenerator.page("abc123").length
  end

  test "page is deterministic for the same address" do
    assert_equal BabelGenerator.page("deadbeef"), BabelGenerator.page("deadbeef")
  end

  test "different addresses give different pages" do
    assert_not_equal BabelGenerator.page("1"), BabelGenerator.page("2")
  end

  test "page contains only the alphabet, spaces, and punctuation" do
    page = BabelGenerator.page("cafe")
    assert_match(/\A[a-z ,.\n]+\z/, page)
  end

  test "sanitize strips non-hex and defaults to the first book" do
    assert_equal "0", BabelGenerator.sanitize(nil)
    assert_equal "0", BabelGenerator.sanitize("")
    assert_equal "abc", BabelGenerator.sanitize("a!b@c#")
    assert_equal "face", BabelGenerator.sanitize("FACE")
  end

  test "vault pages embed their recovered text" do
    assert_includes BabelGenerator.vault_page("1"), "In the infinite library"
    assert_equal 4100, BabelGenerator.vault_page("2").length
  end
end
