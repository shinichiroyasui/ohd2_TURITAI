class User < ActiveRecord::Base
  attr_accessible :gcm_registration_key, :android_id, :access_token, :gender, :birthday

  has_many :user_facebook_places
  has_many :facebook_places, :through => :user_facebook_places

  SEX_MALE = 0
  SEX_FEMALE = 1

  # 特徴のキー
  FEATURE_KEYS = [
   :same_birthday,
   :same_poi_rate,
   :same_book_rate,
   :same_music_rate
  ]

  # 特徴事の重み付け
  # ユーザ毎に異なる重み付けにする
  FEATURE_WEIGHT = {
    same_birthday: 1,
    same_poi_rate: 1,
    same_book_rate: 1,
    same_music_rate: 1
  }

  def fortune_score(other_user)
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
    vector[:same_poi_rate] = same_value_rate((self.pois || "").split(","), (other_user.pois || "").split(","))
    vector[:same_book_rate] = same_value_rate((self.books || "").split(","), (other_user.books || "").split(","))
    vector[:same_music_rate] = same_value_rate((self.musics || "").split(","), (other_user.musics || "").split(","))
    vector
  end

  # ジャッカード係数
  def same_value_rate(array1, array2)
    same_num = (array1 & array2).size
    all_num = (array1 | array2).size
    same_num.to_f / all_num
  end
end
