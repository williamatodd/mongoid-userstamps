class Post
  include Mongoid::Document
  include Mongoid::Userstamps

  field :title
end

