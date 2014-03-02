require 'net/http'
require 'net/https'

class Facebook
  def initialize(access_token)
    @access_token = access_token
  end

  def generate_user!
    user = generate_user_unit!
    user.save

    places = generate_places!
    places.each {|place| place.save }
    (places.uniq - user.facebook_places).each { |place| user.facebook_places << place }

    musics = generate_musics!
    musics.each {|music| music.save }
    (musics.uniq - user.facebook_musics).each { |music| user.facebook_musics << music }

    movies = generate_movies!
    movies.each {|movie| movie.save }
    (movies.uniq - user.facebook_movies).each { |movie| user.facebook_movies << movie }

    user
  end

private
  def generate_user_unit!
    uri = build_uri('/me', {})
    json = get_from_facebook_api(uri)
    id = json['id'].to_i
    gender = parse_gender(json['gender'])
    user = User.where(facebook_id: id).first
    user ||= User.new(facebook_id: id)
    user.access_token = @access_token
    user.gender = gender
    user
  end

  def parse_gender(gender)
    if gender == Settings.facebook.gender.male
      retval = Settings.gender.male
    elsif gender == Settings.facebook.gender.female
      retval = Settings.gender.female
    else
      raise "Illegal Gender"
    end
    retval
  end

  def generate_part!(uri, method)
    array = []
    uri = build_uri(uri, {})
    while uri do
      json = get_from_facebook_api(uri)
      break if json['data'].size == 0
      array.concat __send__(method, json['data'])
      uri = json['paging']['next'] if json['paging']
    end
    array
  end

  def generate_places!
    generate_part!('/me/feed', :get_places_from_me_feed).uniq {|p| p.facebook_id }
  end

  def generate_musics!
    generate_part!('/me/music', :get_musics_from_me_music)
  end

  def generate_movies!
    generate_part!('/me/movies', :get_movies_from_me_movie)
  end

  def build_uri(path, hash)
    param_dup = hash.dup
    param_dup['access_token'] = @access_token
    param_str = param_dup.to_a.map { |k, v| "#{k}=#{v}"}.join("&")
    "#{path}?#{param_str}"
  end

  def get_from_facebook_api(uri)
    https = Net::HTTP.new('graph.facebook.com', 443)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5

    response = https.get(uri)
    # FIXME 通信エラー処理
    JSON.parse(response.body)
  end

  def get_places_from_me_feed(posts)
    places = posts.map {|post| post['place'] }.compact
    places.map {|place| FacebookPlace::parse_and_update_from_facebook_api(place) }
  end

  def get_musics_from_me_music(musics)
    musics.map {|music| FacebookMusic::parse_and_update_from_facebook_api(music) }
  end

  def get_movies_from_me_movie(movies)
    movies.map {|movie| FacebookMovie::parse_and_update_from_facebook_api(music) }
  end
end
