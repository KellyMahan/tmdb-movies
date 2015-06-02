module Tmdb
  class TmdbBase
    attr_accessor :id, :info
    
    def api
      Tmdb.connection
    end
    
    def status_message
      @info.status_message
    end
    
    def changes(options={})
      api.send("#{self.class.name.split('::').last.underscore}_changes", self.id, options)
    end
  end
end