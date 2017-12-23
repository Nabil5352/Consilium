class Reviewer < ApplicationRecord
	belongs_to :user_post,    class_name: "UserPost", foreign_key: "id", optional: true
end
