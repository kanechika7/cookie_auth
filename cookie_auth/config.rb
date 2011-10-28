# coding: UTF-8
require 'cookie_auth/cipher'
module CookieAuth
  module Config
    extend ActiveSupport::Concern
    include CookieAuth::Cipher

    # 
    # ~ How To ~ 
    #
    #   class Member < ActiveRecord::Base
    #     include CookieAuth::Config
    #     cookie_auth_config :qs
    # 
    #     - instance methods -
    #       member.authenticate_key_value => 「 { login: kanechika } 」の暗号化されたもの
    #       member.user_info              => 「 { me: kanechika    } 」view側で使用するユーザ情報 
    #
    #     - class methods -
    #       Member.find_by_authenticate_key_value ( cookies ) => success: member , fail: nil
    #


    module ClassMethods

      def cookie_auth_config service
        class_eval do
          cattr_accessor :service_name
          self.service_name = service
        end
      end

      # class methods
      define_method :find_by_authenticate_key_value do |cookies|
        return nil if cookies["authenticate_key_value"].nil?
        h = ActiveSupport::JSON.decode(cookie_decrypt(cookies["authenticate_key_value"],COOKIE_AUTH_CREDENTIALS[service_name][:authenticate_common_pass]))
        find_by_sql("select * from #{self.to_s.tableize} where #{h.to_a.map{|a| "#{a[0]} = '#{a[1]}'" }.join(' and ')}").first
      end

    end

    module InstanceMethods

      # instance methods
      def setting_cookies(cookies)
        cookies["user_info"] = user_info
        cookies["authenticate_key_value"] = authenticate_key_value
      end

      def authenticate_key_value
        h = {}
        COOKIE_AUTH_CREDENTIALS[self.class.service_name][:authenticate_keys].each{|k| h[k] = send(k) }
        return cookie_encrypt JSON.dump(h), COOKIE_AUTH_CREDENTIALS[self.class.service_name][:authenticate_common_pass]
      end
      def user_info
        h = {}
        COOKIE_AUTH_CREDENTIALS[self.class.service_name][:user_info_fields].each{|f| h[f] = send(f) }
        return JSON.dump h
      end

    end

  end
end
