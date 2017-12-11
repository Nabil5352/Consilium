class ApplicationController < ActionController::Base
	
	protect_from_forgery with: :exception

	before_action :authenticate_user!

	include Pundit
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	def after_sign_in_path_for(resource)
		dashboard_index_path
	end

	private

	def user_not_authorized
		flash[:alert] = "You are not authorized to perform this action."
		redirect_to(request.referrer || root_path)
	end

	def super_admin_only!
		unless current_user.superadmin?
			flash[:alert] = "You are not authorized!"
			redirect_to "/"
		end
	end

	def org_super_admin_only!
		unless current_user.org_super_admin?
			flash[:alert] = "You are not authorized!"
			redirect_to "/"
		end
	end

	def dept_admin_only!
		unless current_user.dept_admin?
			flash[:alert] = "You are not authorized!"
			redirect_to "/"
		end
	end

	def dept_editor_only!
		unless current_user.dept_editor?
			flash[:alert] = "You are not authorized!"
			redirect_to "/"
		end
	end

	def dept_reviewer_only!
		unless current_user.dept_reviewer?
			flash[:alert] = "You are not authorized!"
			redirect_to "/"
		end
	end

	def student_only!
		unless current_user.student?
			flash[:alert] = "You are not authorized!"
			redirect_to "/"
		end
	end
end
