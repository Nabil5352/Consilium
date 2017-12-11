class DeptRequest < ApplicationRecord

	enum request: [:pending, :accepted, :rejected]
	after_initialize :set_default_request, :if => :new_record?

	def set_default_request
		self.status ||= :pending
	end

	validates_uniqueness_of :user_id, scope: [:department_id]

	belongs_to :user
	belongs_to :department, optional: true
end
