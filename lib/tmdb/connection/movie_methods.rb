module Tmdb
  module MovieMethods
    
    
    def movie(id, options={})
      OpenStruct.new(get("/movie/#{id}", options))
    end
    
    
    movie_api_methods = %w(
      latest
      now_playing
      upcoming
      top_rated
      popular
      changes
    )
    
    movie_api_methods.each do |m|
      eval <<-EOF
        def movie_#{m}(options={})
          OpenStruct.new(get("/movie/#{m}", options))
        end
      EOF
    end
    
    
    movie_api_methods_id = %w(
      alternative_titles
      credits
      images
      keywords
      releases
      videos
      translations
      similar
      reviews
      lists
      changes
    )
    
    movie_api_methods_id.each do |m|
      eval <<-EOF
        def movie_#{m}(id, options={})
          OpenStruct.new(get("/movie/\#{id}/#{m}", options))
        end
      EOF
    end
  end
end