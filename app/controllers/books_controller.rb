# frozen_string_literal: true

class BooksController < ApplicationController
  def show
    @book = Book.new(params[:hex])
  end

  # A random address, then on to its page.
  def random
    redirect_to book_path(Book.random.hex)
  end

  # Bounded deterministic phrase search. A hit redirects to the first book
  # in the window that contains the phrase — one stable URL per finding,
  # and nothing is ever stored.
  def search
    phrase = params[:q].to_s.strip
    if phrase.empty?
      flash.now[:alert] = "Type a phrase to search for."
      return render :search
    end

    @phrase = phrase
    @window = Book::SEARCH_WINDOW
    hit = Book.first_containing(phrase)
    if hit
      redirect_to book_path(hit.hex)
    else
      @start = Book.new(Book::DEFAULT_SHELF).hex
      render :search
    end
  end
end
