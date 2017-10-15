class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.api_key
    "f4702b08c0ac6ea5b51425788bb26562"
  end
  
  def self.find_in_tmdb(string)
    Tmdb::Api.key(self.api_key)
    begin
      search_results = Tmdb::Movie.find(string)
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
    
    array_of_movie_hashes = []
    
    if not search_results.nil?
      search_results.each do |movie|
        current_hash = {}
        current_hash[:tmdb_id] = movie.id
        current_hash[:title] = movie.title
        movie_releases = Tmdb::Movie.releases(movie.id)["countries"]
        
        if not movie_releases.blank?
          
          movie_releases.each do |ratings_hash|
            if ratings_hash.has_value?('US') and ratings_hash["certification"] != ""
              current_hash[:rating] = ratings_hash["certification"]
              break
            end
          end
        else
          current_hash[:rating] = 'no rating'
        end
        acceptable_ratings = Set.new ['R', 'PG-13', 'PG', 'G', 'NC-17', 'NR']
        if not acceptable_ratings.include?(current_hash[:rating])
          current_hash[:rating] = 'NR'
        end
        current_hash[:release_date] = movie.release_date
        array_of_movie_hashes << current_hash
      end
    end
    return array_of_movie_hashes
  end
end
