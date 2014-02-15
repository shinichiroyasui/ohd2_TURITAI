require 'net/https'

class PushController < ApplicationController
  AUTHORIZATION_KEY='AIzaSyCkBSgSGrHLC7vdQ9aRc9lbZmijk3JKkDM'
  CONTENT_TYPE_JSON='application/json'

  def send_msg
    user = User.where(id: params[:user_id]).first
    unless user
      # ユーザが見つからなかった
      render status: 400, text: ''
      return
    end

    if params[:data]
      data = JSON.parse(params[:data])
    else
      data = { foo: "bar" }
    end

    code = send_msg_to_gcm_server(user, data)
    # 200であれば成功
    render status: code, text: ''
  end

  private
  # 200であれば成功
  #
  # コード
  # 200 メッセージが正常に処理された。レスポンスのボディにはメッセージ ステータスについての詳細が入っているが、そのフォーマットはリクエストが JSON なのかプレーン テキストなのかどうにより異なる。
  # 400 JSON リクエストに対してのみ適用される。JSON として解析できなかった、または無効なフィールドが含まれていることを示す ( 例えば数値が想定されているのに文字列を渡しているなど ) 。障害の正確な原因はレスポンスに記述されており、リクエストがリトライされる前に、問題に対処する必要がある。
  # 401 センダーのアカウントを認証中にエラーが発生した。
  # 500 リクエストの処理試行中に GCM サーバで内部エラーが発生した。
  # 503 サーバが一時的に使用不可  ( つまりタイムアウトなどが原因で ) を示す。センダーはレスポンスに含まれる Retry-After ヘッダの値を受け取り、後でリトライを行わなければならない。アプリケーション サーバは指数バックオフを実装しなければならない。GCM サーバはリクエストを処理するために時間が掛かりすぎた。
  # http://www.techdoctranslator.com/android/guide/google/gcm/gcm
  def send_msg_to_gcm_server(user, data)
    registration_id = user.googlekey
    json = {
      registration_ids: [registration_id],
      data: data
    }

    https = Net::HTTP.new('android.googleapis.com', 443)
    https.use_ssl = true
    #https.ca_file = hogehoge
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5

    header = {}
    header['Authorization'] = AUTHORIZATION_KEY
    header['Content-Type'] = CONTENT_TYPE_JSON

    response = https.post('/gcm/send', json.to_s, header)
    response.code
  end

end
