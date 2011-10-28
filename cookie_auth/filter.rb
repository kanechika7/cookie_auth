# coding: UTF-8
module CookieAuth
  module Filter
    extend ActiveSupport::Concern

    # 
    # ~ How to ~
    #
    #   $ vi app/controllers/application_controller.rb
    #   
    #   include CookieAuth::Filter
    #   cookie_auth_filter Member, :qs
    #   
    #   - included -
    #   before_filter :cookie_auth_required
    #     # success -> current_member
    #     # fail    -> cookie is none
    #
    #   def cookie_auth_required
    #     current_member = Member.find_by_authenticate_key_value(cookies)
    #     return render text: 'cookie not exist' if current_member.nil?
    #   end
    #
    #


# 未実装
#    module ClassMethods
#    
#      def cookie_auth_filter klass, service
#
#        define_method :cookie_auth_required do
#          m = klass.find_by_authenticate_key_value(cookies)
#        end
#
#        self.before_filter 
#
#        included do
#          send("cookie_auth_#{service}_required")
#        end
#
#      end
#
#    end
#
#
#    def cookie_auth_required
#    end
#
  end

end
