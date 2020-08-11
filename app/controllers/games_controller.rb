require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    1.times { |i| @letters << ['A', 'E', 'I', 'O', 'U'].sample }
    9.times { |i| @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @grid = params[:letters].downcase.split('')
    @entry = params[:word].downcase.split('')
    included_in_grid
    @english = api_call(params[:word])
    final_message
  end

  def included_in_grid
    @check = []
    @entry.each { |letter| @grid.include?(letter) ? @check << letter : @check << 0 }
  end

  def api_call(word)
    attempt = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    attempt_response = JSON.parse(attempt)
    attempt_response['found']
  end

  def final_message
    if @check.include?(0)
      @final_score = "Sorry, but you can only use the letters found in our grid!"
    elsif @english == false
      @final_score = "Sorry, but your entry must be a valid English word."
    else
      @final_score = "Great job! #{@entry.join.upcase} scores #{@entry.length * 100} points!"
    end
  end
end
