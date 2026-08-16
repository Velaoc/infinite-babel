# frozen_string_literal: true

require "test_helper"

class BooksIntegrationTest < ActionDispatch::IntegrationTest
  test "a book page renders generated content at its address" do
    get "/books/1"
    assert_response :success
    assert_select "h1", text: "Volume"
    assert_select "code", text: "1"
    assert_includes response.body, "In the infinite library"
  end

  test "the same address always renders the same page" do
    get "/books/deadbeef"
    first = response.body
    get "/books/deadbeef"
    assert_equal first, response.body
  end

  test "adjacent navigation links exist" do
    get "/books/1"
    assert_select "a[rel=prev]"
    assert_select "a[rel=next]"
  end

  test "random redirects to a book address" do
    get "/books/random"
    assert_response :redirect
    assert_match %r{\Ahttps?://www\.example\.com/books/[0-9a-f]+\z}, response.headers["Location"]
  end

  test "search finds the vault phrase and redirects to its book" do
    get "/books/search", params: { q: "sphere whose exact center" }
    assert_response :redirect
    assert_equal "/books/2", response.headers["Location"]
  end

  test "search with no match renders the empty state" do
    get "/books/search", params: { q: "zzzzzzzzzzzzzzzzzzzz" }
    assert_response :success
    assert_select "p[role=status]"
  end

  test "search with a blank query shows a flash" do
    get "/books/search", params: { q: "   " }
    assert_response :success
    assert_select ".md-snackbar", text: /Type a phrase/
  end

  test "home page shows the first book and the doors into the library" do
    get "/"
    assert_response :success
    assert_select "a[href='/books/random']"
    assert_select "a[href='/books/search']"
  end
end
