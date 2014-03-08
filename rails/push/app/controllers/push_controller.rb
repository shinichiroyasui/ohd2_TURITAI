# coding: utf-8
require 'facebook'

class PushController < ApplicationController

  # registration_idを受け取ってサーバーに保存する
  def gcm_registration_key
    gcm_registration_key = params[:gcm_registration_key]
    android_id = params[:android_id]

    user = User.where(android_id: android_id).first
    user ||= User.new(android_id: android_id)
    user.gcm_registration_key = gcm_registration_key
    if user.save
      render status: 200, :text => ''
    else
      render status: 400, :text => ''
    end
  end

  # fb tokenを受け取ってサーバーに保存する
  def fb_token
    fb_token = params[:fb_token]
    android_id = params[:android_id]

    user = User.where(android_id: android_id).first
    user ||= User.new(android_id: android_id)
    facebook = Facebook.new(fb_token)
    facebook.update_user_attribute!(user)
    # FIXME: エラー時の処理
    render status: 200, :text => ''
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

    cloud_message = Google::CloudMessage.new
    code = cloud_message.send_msg_to_gcm_server(user.gcm_registration_key, data)
    # 200であれば成功
    render status: code, text: ''
  end
end
