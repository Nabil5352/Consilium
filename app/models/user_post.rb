class UserPost < ApplicationRecord

	has_attached_file :document, :path => ":rails_root/public/system/:attachment/:id/:style/:filename"

	allowed_content_type = [
    'application/pdf',
    'image/png',
    'image/jpeg',
    'image/jpg',
    'image/gif'
    ]
	validates_attachment_content_type :document, :content_type => allowed_content_type, :message=> "Only #{allowed_content_type} is allowed"

	enum post_type: [:file, :post, :both]
	enum privacy: [:public_post, :private_post]
	enum genre: [:post_only, :article, :paper, :concept]
	enum edit_status: [:pending, :forwarded, :accepted]
	enum review_status: [:no_reviewer, :on_review, :rejected, :complete]

	after_initialize :set_default_privacy, :if => :new_record?
	after_initialize :set_default_edit_status, :if => :new_record?
	after_initialize :set_default_review_status, :if => :new_record?

	def set_default_privacy
		self.privacy ||= :private_post
	end

	def set_default_edit_status
		self.edit_status ||= :pending
	end

	def set_default_review_status
		self.review_status ||= :no_reviewer
	end

	has_many :comments
	has_one :users
	has_one :editors
	has_many :reviewers,    class_name: "Reviewer", foreign_key: "post_id"
end
