
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
    context 'finds a movie in database' do
      it 'should not return movies for an invalid string' do
        expect(Tmdb::Movie).to receive(:find).with('qvrerqev').and_return([])
        Movie.find_in_tmdb('qvrerqev')
      end
      it 'should return movies for a valid string' do
        return_values = Movie.find_in_tmdb('Ted')
        expect(return_values).not_to be_empty
      end
    end
  end
  describe 'creating TMDB movies' do
    it 'should call create with a parameter hash' do
      fake_hash = {'title' => 'Ted', 'rating' => 'R', 'release_date' => '2012-06-29'}
      expected = {:title => 'Ted', :rating => 'R', :release_date => '2012-06-29'}
      expect(Tmdb::Movie).to receive(:detail).with(72105).and_return(fake_hash)
      expect(Movie).to receive(:create!).with(expected)
      Movie.create_from_tmdb(['72105'])
    end
  end
end
