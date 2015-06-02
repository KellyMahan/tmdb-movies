module Tmdb
  module PeopleMethods
    
    
    def person(id, options={})
      OpenStruct.new(get("/person/#{id}", options))
    end
    
    
    def person_all_changes(options={})
      OpenStruct.new(get("/person/changes", options))
    end
    
    people_api_methods = %w(
      popular
      latest
    )
    
    people_api_methods.each do |m|
      eval <<-EOF
        def person_#{m}(options={})
          OpenStruct.new(get("/person/#{m}", options))
        end
      EOF
    end
    
    people_api_methods_id = %w(
      movie_credits
      tv_credits
      combined_credits
      external_ids
      images
      tagged_images
      changes
    )
    
    people_api_methods_id.each do |m|
      eval <<-EOF
        def person_#{m}(id, options={})
          OpenStruct.new(get("/person/\#{id}/#{m}", options))
        end
      EOF
    end
  end
end