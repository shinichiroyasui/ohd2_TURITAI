require 'net/https'

module Google
  class CloudMessage
    # 200であれば成功
    #
    # コード
    # 200 メッセージが正常に処理された。レスポンスのボディにはメッセージ ステータスについての詳細が入っているが、そのフォーマットはリクエストが JSON なのかプレーン テキストなのかどうにより異なる。
    # 400 JSON リクエストに対してのみ適用される。JSON として解析できなかった、または無効なフィールドが含まれていることを示す ( 例えば数値が想定されているのに文字列を渡しているなど ) 。障害の正確な原因はレスポンスに記述されており、リクエストがリトライされる前に、問題に対処する必要がある。
    # 401 センダーのアカウントを認証中にエラーが発生した。
    # 500 リクエストの処理試行中に GCM サーバで内部エラーが発生した。
    # 503 サーバが一時的に使用不可  ( つまりタイムアウトなどが原因で ) を示す。センダーはレスポンスに含まれる Retry-After ヘッダの値を受け取り、後でリトライを行わなければならない。アプリケーション サーバは指数バックオフを実装しなければならない。GCM サーバはリクエストを処理するために時間が掛かりすぎた。
    # http://www.techdoctranslator.com/android/guide/google/gcm/gcm
    def send_to_server(gcm_registration_key, data)
      gcm_hash = {
        registration_ids: [gcm_registration_key],
        data: data
      }

      https = Net::HTTP.new('android.googleapis.com', 443)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5

      header = {}
      header['Authorization'] = "key=#{Settings.google.cloud_messaging.authorization_key}"
      header['Content-Type'] = Settings.google.cloud_messaging.content_type_json

      response = https.post('/gcm/send', gcm_hash.to_json, header)
      response.code
    end
  end
end
