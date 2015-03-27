# -*- encoding : utf-8 -*-
module Mongoid
  module Userstamps
    module User
      extend ActiveSupport::Concern

      included do
        Mongoid::Userstamps::Config.add_user_class(self)
      end

      def current?
        self.id == self.class.current.try(:id)
      end

      def userstamps_user
        self.class.userstamps_user
      end

      class_methods do
        def current
          Mongoid::Userstamps::Config.current_user(self)
        end

        def current=(value)
          Mongoid::Userstamps::Config.set_current_user(self, value)
        end

        def sudo(user)
          old = self.current
          self.current = user
          yield
        ensure
          self.current = old
        end

        def userstamps_user(opts = {})
          @userstamps_user ||= Mongoid::Userstamps::Config::User.new(opts)
        end
      end
    end
  end
end

