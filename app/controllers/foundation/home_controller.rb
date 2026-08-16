module Foundation
  # The library's front door. This is the product home — a public reading
  # room showing the first book, with doors into the random stacks and
  # search. Replaced the template marketing placeholder.
  class HomeController < ApplicationController
    def show
      @book = Book.new(Book::DEFAULT_SHELF)
    end
  end
end
