module Tmdb
  module SearchMethods
    
    search_api_methods = %w(
      company
      collection
      keyword
      list
      movie
      multi
      person
      tv
    )
    
    search_api_methods.each do |m|
      eval <<-EOF
        def search_#{m}(query, options={})
          options.merge!(query: query)
          OpenStruct.new(get("/search/#{m}", options))
        end
      EOF
    end
  end
end