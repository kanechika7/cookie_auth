# coding: UTF-8
require 'openssl'
module CookieAuth
  module Cipher
    extend ActiveSupport::Concern

    module InstanceMethods
      # 暗号化
      def cookie_encrypt(s, password)
        enc = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
        enc.encrypt
        enc.pkcs5_keyivgen(password)
        return enc.update(s) + enc.final
      end
    end

    module ClassMethods
      # 複合化
      def cookie_decrypt(s, password)
        dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
        dec.decrypt
        dec.pkcs5_keyivgen(password)
        return dec.update(s) + dec.final
      end
    end



  end
end
