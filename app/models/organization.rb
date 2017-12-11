class Organization < ApplicationRecord
	enum status: [:open, :secret, :closed, :inactive]
	after_initialize :set_default_status, :if => :new_record?

	def set_default_status
		self.status ||= :inactive
	end

	has_attached_file :image
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
	has_many :requests,    class_name: "Request", foreign_key: "org_id"
	has_many :users
end
