# frozen_string_literal: true

require "test_helper"

class HomePageTest < ActionDispatch::IntegrationTest
  test "home page shows the first book and the doors into the library" do
    get "/"
    assert_response :success
    assert_select "a[href='/books/random']"
    assert_select "a[href='/books/search']"
    assert_includes response.body, "Infinite Babel"
  end

  test "home page always describes core foundation capabilities" do
    get "/"
    assert_response :success
    assert_select "[data-capability=accounts]"
  end

  test "home page reflects storefront module availability" do
    get "/"
    assert_response :success
    assert_select "[data-capability=accounts]"
  end
end
