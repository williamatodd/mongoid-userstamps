# -*- encoding : utf-8 -*-

module Mongoid
  module Userstamps
    module Config
      class User
        attr_accessor :reader

        def initialize(opts = {})
          @reader = opts[:reader]
        end

        def reader
          @reader || Mongoid::Userstamps::Config.user_reader
        end
      end
    end
  end
end

