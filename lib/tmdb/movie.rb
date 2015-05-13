module Tmdb
  module Movie
    def movie(id)
      OpenStruct.new(get("/movie/#{id}"))
    end
  end
end