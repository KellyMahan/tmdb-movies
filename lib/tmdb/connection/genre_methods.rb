module Tmdb
  module GenreMethods
    
    def genre_movie_list
      OpenStruct.new(get("/genre/movie/list"))
    end
    
    def genre_tv_list
      OpenStruct.new(get("/genre/tv/list"))
    end
    
    def genre_movies(id, options={})
      OpenStruct.new(get("/genre/#{id}/movies", options))
    end
  end
end