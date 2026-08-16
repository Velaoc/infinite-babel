# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: :show

  def show
    @book = Book.new(params[:hex])
  end

  # A random address, then on to its page.
  def random
    redirect_to book_path(Book.random.hex)
  end

  # Bounded deterministic phrase search. A found book is a redirect to its
  # address — one stable URL per hit, nothing stored.
  def search
    phrase = params[:q].to_s.strip
    if phrase.empty?
      flash.now[:alert] = "Type a phrase to search for."
      return render :search
    end

    @phrase = phrase
    @window = Book::SEARCH_WINDOW
    @results = Book.first_containing(phrase).present? ? [ Book.first_containing(phrase) ] : []
    render :search
  end

  private

  def set_book
    @book = Book.new(params[:hex])
  end
end
