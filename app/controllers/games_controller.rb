# frozen_string_literal: true

require 'open-uri'
require 'json'
require 'net/http'

# Adding a comment
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def http_request(word)
    uri = URI("https://wagon-dictionary.herokuapp.com/#{word}")
    result = Net::HTTP.get_response(uri)
    JSON.parse(result.body)
  end

  def include?(grid, word)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def score
    @grid = params['grid']
    @word = params['word'].upcase
    @hash = http_request(@word)
    @result = if @hash['found'] == false
                'not a word'
              elsif include?(@grid.split(''), @hash['word']) == false
                'not in grid'
              else
                'valid'
              end
  end
end
