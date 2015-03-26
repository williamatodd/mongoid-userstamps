module Mongoid
  module Userstamps
    module Model
      extend ActiveSupport::Concern

      included do
        Mongoid::Userstamps::Config.add_model_class(self)
      end

      def userstamps_model
        self.class.userstamps_model
      end

      class_methods do
        def userstamps_model(opts = {})
          @userstamps_model ||= Mongoid::Userstamps::Config::Model.new(opts)
        end

        def current_user
          Mongoid::Userstamps::Config.current_user(userstamps_model.user_model)
        end
      end
    end
  end
end

