require "json"
require "open-uri"

class GamesController < ApplicationController
  def home
  end

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:letter]
    @grid = params[:grid]
    if include_grid?(@guess.upcase, @grid)
      english_word?(@guess) ? @result = "Congratulations! #{@guess} is a valid word." : @result = "#{@guess} is not a valid English word."
    else
      @result = 'not in the grid'
    end
  end

  private

  def english_word?(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    response = URI.open(url).read
    @json = JSON.parse(response)
    @json['found']
  end

  def include_grid?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
