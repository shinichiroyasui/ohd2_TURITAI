# 運命度を算出するライブラリ
class DistinyScoreMatcher
  # 全件更新
  # FIXME: 規模が大きくなると死ぬこと必至. LSHや乱択や直近に更新しているユーザに限るなど更新対象の絞込みが必要
  def update_all
    users = User.all
    users.combination(2) do |user1, user2|
      # 方向があるので両面を更新する
      update_each(user1, user2)
      update_each(user2, user1)
    end
  end

  # 1件ずつ更新
  # FIXME: 規模が大きくなると死ぬこと必至. バルクアップデート方法を模索
  def update_each(user1, user2)
    score = user1.calc_distiny_score(user2)
    user_destiny_score = UserDestinyScore.where(user1_id: user1.id)
                                         .where(user1_id: user2.id)
                                         .first
    user_destiny_score ||= UserDestinyScore.new(user1_id: user1.id, user2_id: user2.id)
    user_destiny_score.score = score
    user_destiny_score.save!
  end

  # ユーザ以外の、未だマッチングしていない、最も運命度が高いユーザを検索
  def find_target_user(user_place)
    place = FacebookPlace.where(:id => user_place.facebook_place_id)
    # FIXME: 直近に通知したことあるユーザを除く対象として追加する
    except_user_ids = [user_place.user_id]
    place_user_ids = UserFacebookPlace.select(:user_id).where(:facebook_place_id => user_place.facebook_place_id).map(&:user_id)
    candidate_user_ids = place_user_ids - except_user_ids
    target_user_id = UserDestinyScore.where(:user1_id => user_place.user_id, :user2_id => candidate_user_ids).order('score DESC').first.user2_id
    User.where(:id => target_user_id).first
  end

  def notify
    # FIXME: 通知結果を保存
  end
end
