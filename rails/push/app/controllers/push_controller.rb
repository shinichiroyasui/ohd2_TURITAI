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
end
