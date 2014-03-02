class User < ActiveRecord::Base
  attr_accessible :facebook_id, :gcm_registration_key, :android_id, :access_token, :gender, :birthday

  has_many :user_facebook_places
  has_many :facebook_places, :through => :user_facebook_places

  has_many :user_facebook_musics
  has_many :facebook_musics, :through => :user_facebook_musics

  has_many :user_facebook_movies
  has_many :facebook_movies, :through => :user_facebook_movies

  # 特徴のキー
  FEATURE_KEYS = [
   :same_birthday,
   :same_poi_rate,
   #:same_book_rate,
   :same_movie_rate
  ]

  # 特徴事の重み付け
  # ユーザ毎に異なる重み付けにする
  FEATURE_WEIGHT = {
    same_birthday: 1,
    same_poi_rate: 1,
    same_book_rate: 1,
    same_music_rate: 1,
    same_movie_rate: 1
  }

  def calc_distiny_score(other_user)
    vector = convert_feature_vector(other_user)
    logger.debug { "user1: #{self.inspect}" }
    logger.debug { "user2: #{other_user.inspect}" }
    logger.debug { "vector: #{vector.inspect}" }
    # 重み付け線形和
    FEATURE_KEYS.sum { |key| vector[key] * FEATURE_WEIGHT[key] }
  end

private
  def convert_feature_vector(other_user)
    vector = {}
    vector[:same_birthday] = (self.birthday == other_user.birthday) ? 1 : 0
    vector[:same_poi_rate] = same_value_rate(facebook_places.map(&:id), other_user.facebook_places.map(&:id))
    #vector[:same_book_rate] = same_value_rate((self.books || "").split(","), (other_user.books || "").split(","))
    vector[:same_music_rate] = same_value_rate(facebook_musics.map(&:id), other_user.facebook_musics.map(&:id))
    vector[:same_movie_rate] = same_value_rate(facebook_movies.map(&:id), other_user.facebook_movies.map(&:id))
    STDERR.puts vector.inspect
    vector
  end

  # ジャッカード係数
  def same_value_rate(array1, array2)
    all_num = (array1 | array2).size
    return 0 if all_num == 0
    same_num = (array1 & array2).size
    same_num.to_f / all_num
  end
end
