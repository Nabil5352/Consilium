class User < ApplicationRecord

	enum role: [:superadmin, :user, :org_super_admin, :dept_admin, :dept_editor, :dept_reviewer, :student]
	after_initialize :set_default_role, :if => :new_record?

	def set_default_role
		self.role ||= :user
	end

	has_many :requests
	has_many :dept_requests
	has_many :user_posts

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		:recoverable, :rememberable, :trackable, :validatable
end
