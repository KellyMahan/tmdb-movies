require 'httparty'
require 'tmdb/connection/movie_methods'
require 'tmdb/connection/people_methods'
require 'tmdb/connection/genre_methods'
require 'tmdb/connection/search_methods'

module Tmdb
  
  @@connection = nil
  
  def self.connection
    @@connection
  end
  
  def self.connection=(c)
    @@connection = c
  end
  
  def self.connect
    Tmdb::Connection.new
  end
  
  class Connection
    include HTTParty
    include MovieMethods
    include PeopleMethods
    include GenreMethods
    include SearchMethods
    # debug_output $stdout
    
    attr_accessor :api_key, :response, :request
    
    
    TMDB_URL = "http://api.themoviedb.org/3"
    
    def initialize(api_key = ENV["TMDB_API_KEY"])
      @api_key = api_key
      Tmdb.connection = self
    end
        
    private
    
    def get(url, params={})
      params.merge!({api_key: @api_key, language: params[:language]||"en"})
      @response = self.class.get(TMDB_URL + url, query: params)
      @request = @response.request
      return @response
    end
    
    def post(url, params={})
      params.merge!({api_key: @api_key, language: params[:language]||"en"})
      @response = self.class.post(TMDB_URL + url, query: params)
      @request = @response.request
      return @response
    end
  end
end