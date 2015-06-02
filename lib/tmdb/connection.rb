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
    @@connection ||= Tmdb::Connection.new
  end
  
  class Connection
    include HTTParty
    include MovieMethods
    include PeopleMethods
    include GenreMethods
    include SearchMethods
    # debug_output $stdout
    
    attr_accessor :api_key, :response, :request, :rate_limit_time
    
    CONNECTIONS_PER_MINUTE = 150.0
    CONNECTION_SPACING = 60.0/CONNECTIONS_PER_MINUTE
    TMDB_URL = "http://api.themoviedb.org/3"
    
    def initialize(api_key = ENV["TMDB_API_KEY"])
      @api_key = api_key
      Tmdb.connection = self
    end
        
    
    def rate_limit
      while(Time.now.to_f<@rate_limit_time.to_f+CONNECTION_SPACING)
        sleep 0.1
      end
      @rate_limit_time = Time.now
    end
    
    private
    
    def get(url, params={})
      params.merge!({api_key: @api_key, language: params[:language]||"en"})
      rate_limit
      @response = self.class.get(TMDB_URL + url, query: params)
      @request = @response.request
      return @response
    end
    
    def post(url, params={})
      params.merge!({api_key: @api_key, language: params[:language]||"en"})
      rate_limit
      @response = self.class.post(TMDB_URL + url, query: params)
      @request = @response.request
      return @response
    end
    
  end
end