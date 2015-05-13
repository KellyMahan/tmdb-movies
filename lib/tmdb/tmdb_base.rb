module Tmdb
  class TmdbBase
    attr_accessor :id, :info
    
    def api
      Tmdb.connection
    end
  end
end