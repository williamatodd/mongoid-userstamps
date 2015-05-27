# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamps
    module Updated
      extend ActiveSupport::Concern

      included do
        if !self.included_modules.include?(Mongoid::Userstamps::Model)
          include Mongoid::Userstamps::Model
        end

        belongs_to userstamps_config.updated_name, {
          class_name: userstamps_model.user_model,
          inverse_of: nil
        }

        set_callback :save, :before, :set_updated_by
      end

      def set_updated_by
        user = self.class.current_user
        return if !user || self.public_send("#{userstamps_config.updated_name}_id_changed?")
        self.public_send("#{userstamps_config.updated_name}=", user)
      end
    end
  end
end

