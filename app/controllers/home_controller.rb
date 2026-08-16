# frozen_string_literal: true

# The library's front door and its pages. All of it is public — a visitor
# reads without an account, exactly as a library should be.
class HomeController < ApplicationController
  def show
    @book = Book.new(Book::DEFAULT_SHELF)
  end
end
