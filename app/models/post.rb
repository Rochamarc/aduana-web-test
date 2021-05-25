class Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :user_id, :body 
end
