class DashboardController < ApplicationController
	
	before_action :super_admin_only!, only: [:super_admin, :activate_organization, :reject_organization]
	before_action :org_super_admin_only!, only: [:organization_super_admin, :approve_org_user, :reject_org_user]
	before_action :dept_admin_only!, only: [:organization_dept_admin]
	before_action :dept_editor_only!, only: [:organization_editors]
	before_action :dept_reviewer_only!, only: [:organization_reviewers]
	before_action :student_only!, only: [:organization_students]

	def index
		if current_user.superadmin?
			redirect_to super_admin_dashboard_index_path
		elsif current_user.org_super_admin?
			redirect_to organization_super_admin_dashboard_index_path
		elsif current_user.dept_admin?
			redirect_to organization_dept_admin_dashboard_index_path
		elsif current_user.dept_editor?
			redirect_to organization_editors_dashboard_index_path
		elsif current_user.dept_reviewer?
			redirect_to organization_reviewers_dashboard_index_path
		elsif current_user.student?
			redirect_to organization_students_dashboard_index_path
		end

		@organizations = Organization.all.where.not(status: "inactive").where.not(status: "secret")
		@currentUser = current_user.id
	end

	def super_admin
		@organizations = Organization.all.where(status: "inactive")
	end

	def organization_super_admin
		@departments = Department.all

		@currentUser = current_user
		@org_id = @currentUser.organization_id
		@requests = Request.all.where(org_id: @org_id)
	end

	def activate_organization
		@organization = Organization.find(params[:id])
		setStatus = Organization.statuses[:closed]
		@organization.status = setStatus

		@user = User.new
		@user.email = @organization.email
		@generated_password = Devise.friendly_token.first(10)
		@user.password = @generated_password
		@user.role = User.roles[:org_super_admin]
		@user.organization_id = @organization.id

		if User.exists?(@organization.email)
			flash[:alert] = "User exists. You have to change email address."
			render :super_admin
		else
			if @organization.save
				if @user.save
					OrgNotificationMailer.organization_created_notification(@organization.name, @user.email, @generated_password).deliver
				end
				flash[:success] = "Organization has been activated!"
				redirect_to dashboard_index_path
			else
				flash[:alert] = "Organization can not be activated."
				render :super_admin
			end
		end
		
	end

	def reject_organization
	end

	def org_join_request
		@organizations = Organization.all.where.not(status: "inactive").where.not(status: "secret")
		@org_id = Organization.find(params[:id])
		@currentUser = current_user.id

		@request = Request.new
		@request.user_id = @currentUser
		@request.org_id = @org_id.id
		@request.status = Request.requests[:pending]
		@request.requested_at = Time.now

		if @request.save
			flash[:success] = "Request has been sent successfully."
			redirect_to dashboard_index_path
		else
			flash[:alert] = "An error occurred. Please try again."
			render :index
		end
	end

	def approve_org_user
		@request = Request.find(params[:id])
		@request.status = Request.requests[:accepted]

		@requestee_id = @request.user_id
		@requestee = User.find(@requestee_id)
		@requestee.organization_id = @request.org_id

		if @request.save and @requestee.save
			flash[:success] = "Approved user"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			redirect_to dashboard_index_path
		end
	end

	def reject_org_user
		@request = Request.find(params[:id])
		@request.status = Request.requests[:rejected]

		if @request.save
			flash[:alert] = "User rejected"
			redirect_to dashboard_index_path
		end
	end

	def organization_dept_admin
		@currentUser = current_user
		@dept_id = @currentUser.department_id
		@requests = DeptRequest.all.where(department_id: @dept_id).order("requests desc")

		@currentUser = User.find(current_user.id)
		@cu_org_id = @currentUser.organization_id
		@cu_dept_id = @currentUser.department_id
		@cu_dept_members = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:student])
		@cu_dept_editors = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_editor])
		@cu_dept_reviewers = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_reviewer])
		@cu_organization = Organization.find(@cu_org_id)
		@cu_department = Department.find(@cu_dept_id)
		@organizations = Organization.all.where.not(status: "inactive").where.not(status: "secret")

		@this_dept_admin = @currentUser.role == "dept_admin" ? true : false

		@user_post = UserPost.new
		@all_post = UserPost.all.where(privacy: UserPost.privacies[:public_post]).order(created_at: :desc)

		@assing_candidates = User.all.where(organization_id: @cu_org_id).where(role: "user")
	end

	def dept_join_request
		@organization = Organization.find(params[:o_id])
		@dept_id = Department.find(params[:id])
		@currentUser = current_user.id

		@d_request = DeptRequest.new
		@d_request.user_id = @currentUser
		@d_request.department_id = @dept_id.id
		@d_request.status = DeptRequest.requests[:pending]
		@d_request.requests = Time.now

		if @d_request.save!
			flash[:success] = "Request has been sent successfully."
			redirect_to organization_path(@organization)
		else
			flash[:alert] = "An error occurred. Please try again."
			redirect_to organization_path(@organization)
		end
	end

	def approve_dept_user
		@request = DeptRequest.find(params[:id])
		@request.status = DeptRequest.requests[:accepted]

		@requestee_id = @request.user_id
		@requestee = User.find(@requestee_id)
		@requestee.department_id = @request.department_id
		@requestee.role = User.roles[:student]

		if @request.save and @requestee.save
			flash[:success] = "Approved user"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			redirect_to dashboard_index_path
		end
	end

	def reject_dept_user
		@request = DeptRequest.find(params[:id])
		@request.status = DeptRequest.requests[:rejected]
		@requestee_id = @request.user_id
		@requestee = User.find(@requestee_id)
		@requestee.role = User.roles[:user]

		if @request.save
			flash[:alert] = "User rejected"
			redirect_to dashboard_index_path
		end
	end

	def organization_editors
		@currentUser = current_user
		@dept_id = @currentUser.department_id
		@requests = DeptRequest.all.where(department_id: @dept_id).order("requests desc")

		@currentUser = User.find(current_user.id)
		@cu_org_id = @currentUser.organization_id
		@cu_dept_id = @currentUser.department_id
		@cu_dept_members = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:student])
		@cu_dept_editors = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_editor])
		@cu_dept_reviewers = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_reviewer])
		@cu_organization = Organization.find(@cu_org_id)
		@cu_department = Department.find(@cu_dept_id)
		@organizations = Organization.all.where.not(status: "inactive").where.not(status: "secret")

		@this_dept_admin = @currentUser.role == "dept_admin" ? true : false

		@user_post = UserPost.new
		@all_post = UserPost.all.where(privacy: UserPost.privacies[:public_post]).order(created_at: :desc)
		@post_requests = UserPost.all.where(privacy: UserPost.privacies[:private_post])
	end

	def forward_for_review
		@post = UserPost.find(params[:id])
		@post.edit_status = UserPost.edit_statuses[:forwarded]

		if @post.save
			flash[:success] = "Forwarded successfully"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			redirect_to dashboard_index_path
		end
	end

	def organization_reviewers
		@currentUser = current_user
		@dept_id = @currentUser.department_id
		@requests = DeptRequest.all.where(department_id: @dept_id).order("requests desc")

		@currentUser = User.find(current_user.id)
		@cu_org_id = @currentUser.organization_id
		@cu_dept_id = @currentUser.department_id
		@cu_dept_members = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:student])
		@cu_dept_editors = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_editor])
		@cu_dept_reviewers = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_reviewer])
		@cu_organization = Organization.find(@cu_org_id)
		@cu_department = Department.find(@cu_dept_id)
		@organizations = Organization.all.where.not(status: "inactive").where.not(status: "secret")

		@this_dept_admin = @currentUser.role == "dept_admin" ? true : false

		@user_post = UserPost.new
		@all_post = UserPost.all.where(privacy: UserPost.privacies[:public_post]).order(created_at: :desc)
		@review_posts = UserPost.all.where(edit_status: UserPost.edit_statuses[:forwarded])

		@review = Reviewer.new
	end

	def reviewer_accepted
		@post = UserPost.find(params[:id])
		@post.review_status = UserPost.review_statuses[:on_review]

		if @post.save
			flash[:success] = "Accepted"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			redirect_to dashboard_index_path
		end
	end

	def reviewer_rejected
		@post = UserPost.find(params[:id])
		@post.review_status = UserPost.review_statuses[:rejected]

		if @post.save
			flash[:success] = "Accepted"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			redirect_to dashboard_index_path
		end
	end

	def organization_students
		@currentUser = User.find(current_user.id)
		@cu_org_id = @currentUser.organization_id
		@cu_dept_id = @currentUser.department_id
		@cu_dept_members = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:student])
		@cu_dept_editors = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_editor])
		@cu_dept_reviewers = User.all.where(department_id: @cu_dept_id).where(role: User.roles[:dept_reviewer])
		@cu_organization = Organization.find(@cu_org_id)
		@cu_department = Department.find(@cu_dept_id)
		@organizations = Organization.all.where.not(status: "inactive").where.not(status: "secret")
		@reviews = Reviewer.all.where(department_id: @cu_dept_id)

		@this_dept_admin = @currentUser.role == "dept_admin" ? true : false

		@user_post = UserPost.new
		@all_post = UserPost.all.where(privacy: UserPost.privacies[:public_post]).order(created_at: :desc)

		@reviewed_post = UserPost.all.where(user_id: current_user.id)
	end
end
