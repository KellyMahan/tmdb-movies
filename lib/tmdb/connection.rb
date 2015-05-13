require 'httparty'
module Tmdb
  class Connection
    include HTTParty
    include Movie
    # debug_output $stdout
    
    attr_accessor :api_key, :response, :request
    
    
    TMDB_URL = "http://api.themoviedb.org/3"
    
    def initialize(api_key = ENV["TMDB_API_KEY"])
      @api_key = api_key
    end
    
    
    private
    
    def get(url, params={})
      params.merge!({api_key: @api_key})
      @response = self.class.get(TMDB_URL + url, query: params)
      @request = @response.request
      return @response
    end
    
    def post(url, params={})
      params.merge!({api_key: @api_key})
      @response = self.class.post(TMDB_URL + url, query: params)
      @request = @response.request
      return @response
    end
  end
end