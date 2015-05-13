module Tmdb
  class Movie < TmdbBase
        
    def initialize(id)
      @id = id
      @info = api.movie(id)
    end
    
    def images
      @images ||= api.movie_images(id)
    end
    
    def posters
      images.posters.map{|p| OpenStruct.new(p)}
      unless images.map{|i| i.file_path}.includes?(poster_path)
        images << OpenStruct.new({file_path: poster_path})
      end
    end
    
    def backdrops
      images = images.backdrops.map{|p| OpenStruct.new(p)}
      unless images.map{|i| i.file_path}.includes?(backdrop_path)
        images << OpenStruct.new({file_path: backdrop_path})
      end
    end
    
    def cast
      @cast ||= api.movie_credits(id).cast.map{|c| OpenStruct.new(c)}
    end
    
    def crew
      @crew ||= api.movie_credits(id).crew.map{|c| OpenStruct.new(c)}
    end
    
    def videos
      @crew ||= api.movie_videos(id).map{|t| OpenStruct.new(t)}
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