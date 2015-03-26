# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamps
    module Config
      class Model
        attr_accessor :created_name
        attr_accessor :updated_name
        attr_accessor :deleted_name
        attr_accessor :user_model

        def initialize(opts = {})
          @created_name = opts[:created_name]
          @updated_name = opts[:updated_name]
          @user_model   = opts[:user_model]
        end

        def created_name
          @created_name || Mongoid::Userstamps::Config.created_name
        end

        def updated_name
          @updated_name || Mongoid::Userstamps::Config.updated_name
        end

        def deleted_name
          @deleted_name || Mongoid::Userstamps::Config.deleted_name
        end

        def user_model
          @user_model || Mongoid::Userstamps::Config.user_classes.first.to_s
        end
        def user_model=(value)
          @user_model = value.to_s if value
        end
        def user_model_defined?
          !!@user_model
        end
      end
    end
  end
end

