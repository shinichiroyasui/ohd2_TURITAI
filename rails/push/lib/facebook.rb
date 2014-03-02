require 'net/http'
require 'net/https'

class Facebook
  def initialize(access_token)
    @access_token = access_token
  end

  def get_places_all
    posts = []

    uri = build_uri('/me/feed', {})
    while uri do
      json = get_from_facebook_api(uri)
      break if json['data'].size == 0
      posts.concat get_places_from_post_hash(json['data'])
      uri = json['paging']['next'] if json['paging']
    end
    posts
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

  def get_places_from_post_hash(posts)
    places = posts.map {|post| post['place'] }.compact
    places.map {|place| FacebookPlace::parse_and_update_from_facebook_api(place) }
  end
end
