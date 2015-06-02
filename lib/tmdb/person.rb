module Tmdb
  class Person < TmdbBase
    
    def initialize(id)
      @id = id
      @info = api.person(id)
    end
    
    def images
      api.person_images(id).profiles.map{|i| OpenStruct.new(i)}
    end
    
    def movies
      api.person_movie_credits(id).cast.map{|c| OpenStruct.new(c)}
    end
    
    def method_missing(method, *args, &block)
      if @info.respond_to?(method)
        @info.send(method, *args, &block)
      else
        super
      end
    end
  end
end