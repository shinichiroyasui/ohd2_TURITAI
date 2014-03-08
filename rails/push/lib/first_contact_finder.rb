# 定期更新し、新規投稿されたplaceに対してユーザを検索し通知する
class FirstContactFinder
  def run
    matcher = DistinyScoreMatcher.new
    updated_result = update_user_places!
    user_places = updated_result.find_updated_user_places
    user_places.each do |user_place|
      target_user = matcher.find_target_user(user_place)
      # FIXME: マルチデバイスに対応する場合はスイッチする機構が必要
      notifier = CloudMessageNotifier.new(target_user, user_place.facebook_place)
      matcher.notify(tareget_user) if notifier.notify
      # 失敗した場合は?
    end
  end

  private

  # 位置情報を更新
  def update_user_places!
    before_update_at = Time.now
    user_ids = User.select(:id)
    user_ids.slice(1000) do |slieced_user_ids|
      User.where(:id => sliced_user_ids).each do |user|
        puts user.id
        facebook = Facebook.new(access_token)
        # 全件更新するのは時間がかかるので、差分更新出来たほうがいいかも
        facebook.update_user_attribute!(user)
      end
    end
    Result.new(before_update_at)
  end

  # アップデート結果
  class Result
    def initialize(before_update_at)
      @before_update_at = before_update_at
    end

    def find_updated_user_places
      UserFacebookPlace.where('created_at >= ?', @before_update_at).all
    end
  end

  # 通知
  class NotifierBase
    attr_reader :user, :place

    def initialize(user, place)
      @user = user
      @place = place
    end

    def notify!
      raise NotImplementedError
    end
  end

  # Google Cloud Messageを使用した通知
  class CloudMessageNotifier < NotifierBase
    def initialize(user, place)
      super(user, place)
      @cloud_message = Google::CloudMessage.new
    end

    def notify!
      data = {} # FIXME
      @cloud_message.send_to_server(@user.gcm_registration_key, data) == 200
    end
  end
end
