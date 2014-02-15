class User < ActiveRecord::Base
  attr_accessible :id, :googlekey, :birthday, :sex
  SEX_MALE=0
  SEX_FEMALE=1

  # 特徴のキー
  FEATURE_KEYS = [:same_birthday]
  # ユーザ毎に異なる重み付けにする
  FEATURE_WEIGHT = {:same_birthday => 1}

  def fortune_score(other_user)
    vector = convert_feature_vector(other_user)
    FEATURE_KEYS.sum { |key| vector[key] * FEATURE_WEIGHT[key] }
  end

private
  def convert_feature_vector(other_user)
    vector = {}
    vector[:same_birthday] = (self.birthday == other_user.birthday) ? 1 : 0
    vector
  end
end
