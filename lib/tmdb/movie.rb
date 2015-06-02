module Tmdb
  class Movie < TmdbBase
        
    def initialize(id)
      @id = id
      @info = api.movie(id)
    end
    
    def images
      api.movie_images(id)
    end
    
    def posters
      _images = images.posters.map{|p| OpenStruct.new(p)}
      unless _images.map{|i| i.file_path}.include?(poster_path)
        _images << OpenStruct.new({file_path: poster_path})
      end
      return _images
    end
    
    def backdrops
      _images = images.backdrops.map{|p| OpenStruct.new(p)}
      unless _images.map{|i| i.file_path}.include?(backdrop_path)
        _images << OpenStruct.new({file_path: backdrop_path})
      end
      return _images
    end
    
    def cast
      api.movie_credits(id).cast.map{|c| OpenStruct.new(c)}
    end
    
    def crew
      api.movie_credits(id).crew.map{|c| OpenStruct.new(c)}
    end
    
    def videos
      api.movie_videos(id).map{|t| OpenStruct.new(t)}
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