class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.api_key
    'f4702b08c0ac6ea5b51425788bb26562'
  end
  def self.find_in_tmdb(string)
    begin
      Tmdb::Movie.find(string)
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end

end
