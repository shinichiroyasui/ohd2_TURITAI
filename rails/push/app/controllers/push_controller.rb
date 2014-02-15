# coding: utf-8
require 'net/https'

class PushController < ApplicationController
  AUTHORIZATION_KEY='AIzaSyCkBSgSGrHLC7vdQ9aRc9lbZmijk3JKkDM'
  CONTENT_TYPE_JSON='application/json'

  # registration_id, fb tokenを受け取ってサーバーに保存する
  def send_info
    fb_token = params[:fb_token]
    gcm_registration_id = params[:gcm_registration_id]
    android_id = params[:android_id]

    # FIXME 多重登録対策
    create_result = User.create(
                      googlekey: gcm_registration_id,
                      accesstoken: fb_token
                    )
    if create_result
      render status: 200, :text => ''
    else
      render status: 400, :text => ''
    end
  end

  def poi_to_user(poi_id, except_user)
    user_ids = Userspot.where(poiid: poi_id).where("userid <> ?", except_user.id).select(:userid).all.map(&:userid)
    max_score_pairscore = Pairscore.where(userid1: user_ids).order("score DESC").first
    oppose_user_id = max_score_pairscore.userid2
    oppose_user = User.find oppose_user_id
  end

  def ge
    user = User.where(id: params[:user_id]).first
    unless user
      logger.error "ユーザが見つかりませんでした"
      render status: 400, text: ''
      return
    end
    poi_id = params[:poi_id]

    oppose_user = poi_to_user(poi_id, user)
    data = {"message" => "ba-ka"}
    code = send_msg_to_gcm_server(oppose_user, data)

    # 200であれば成功
    render status: code, text: ''
  end

  def send_msg
    user = User.where(id: params[:user_id]).first
    unless user
      logger.error "ユーザが見つかりませんでした"
      render status: 400, text: ''
      return
    end

    if params[:data]
      data = JSON.parse(params[:data])
      logger.debug "json: #{data.to_s}"
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
    logger.info "registration_id: #{registration_id}"
    gcm_hash = {
      registration_ids: [registration_id],
      data: data
    }

    https = Net::HTTP.new('android.googleapis.com', 443)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5

    header = {}
    header['Authorization'] = "key=#{AUTHORIZATION_KEY}"
    header['Content-Type'] = CONTENT_TYPE_JSON

    response = https.post('/gcm/send', gcm_hash.to_json, header)
    response.code
  end
end
