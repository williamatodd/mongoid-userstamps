# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamps
    module Config
      class Model
        def initialize(model)
          @model = model
          @user_model = nil
        end

        def config
          Mongoid::Userstamps::Config
        end

        def user_model
          @user_model || config.user_classes.first.to_s
        end

        def user_model=(value)
          @user_model = value.to_s if value
          set_user_model!
        end

        def set_user_model!
          @model.relations[config.created_name.to_s].try(:[]=, :class_name, user_model)
          @model.relations[config.updated_name.to_s].try(:[]=, :class_name, user_model)
          @model.relations[config.deleted_name.to_s].try(:[]=, :class_name, user_model)
        end
      end
    end
  end
end

