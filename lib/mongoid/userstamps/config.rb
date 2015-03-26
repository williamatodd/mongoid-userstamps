# -*- encoding : utf-8 -*-

require 'mongoid/userstamps/config/model'
require 'mongoid/userstamps/config/user'

module Mongoid
  module Userstamps
    module Config
      class << self
        attr_accessor :created_name
        attr_accessor :updated_name
        attr_accessor :deleted_name
        attr_accessor :user_reader

        def eval
          instance_eval(&Proc.new)
        end

        def user_classes
          @user_classes ||= []
        end

        def add_user_class(klass)
          user_classes << klass
          model_classes.each do |model|
            config = model.userstamps_model
            if !config.user_model_defined?
              model.relations[config.created_name.to_s].try(:[]=, :class_name, config.user_model)
            end
          end
        end

        def model_classes
          @model_classes ||= []
        end

        def add_model_class(klass)
          model_classes << klass
        end

        def created_name
          @created_name ||= :created_by
        end

        def updated_name
          @updated_name ||= :updated_by
        end

        def deleted_name
          @deleted_name ||= :deleted_by
        end

        def user_reader
          @user_reader ||= :current_user
        end

        def current_user(user_class)
          store(user_class)
        end

        def set_current_user(user_class, value)
          store(user_class, value)
        end

        def store(model, value = false)
          return if !model
          key = "mongoid-userstamps/#{model.to_s.underscore}".to_sym
          store = defined?(RequestStore) ? RequestStore.store : Thread.current
          if value == false
            store[key]
          else
            store[key] = value
          end
        end
      end
    end
  end
end

