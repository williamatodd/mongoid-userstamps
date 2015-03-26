# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamps
    module Created
      extend ActiveSupport::Concern

      included do
        if !self.included_modules.include?(Mongoid::Userstamps::Model)
          include Mongoid::Userstamps::Model
        end

        belongs_to userstamps_model.created_name, {
          class_name: userstamps_model.user_model,
          inverse_of: nil
        }

        set_callback :create, :before, :set_created_by
      end

      def set_created_by
        user = self.class.current_user
        return if !user || self.public_send(userstamps_model.created_name)
        self.public_send("#{userstamps_model.created_name}=", user)
      end
    end
  end
end

