class DepartmentsController < ApplicationController

	before_action :org_super_admin_only!, only: [:new, :change_admin, :update_admin, :edit, :create, :update, :destroy]
	before_action :dept_admin_only!, only: [:dept_settings]

	def new
		@department = Department.new
	end

	def create
		@currentUser = current_user
		@department = Department.new(department_params)
		@department.organization_id = @currentUser.organization_id
		
		if @department.save
			flash[:success] = "Department has been created successfully"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			render :new
		end
	end

	def dept_settings
	end

	def change_admin
		@department = Department.find(params[:id])
		@reg_users = User.all.where(organization_id: @department.organization_id).where(role: :user)
	end

	def update_admin
		dept_admin = User.find(params[:name])
		dept_admin.role = User.roles[:dept_admin]
		dept_admin.department_id = params[:department_id]

		if dept_admin.save
			flash[:success] = "Department admin has been changed successfully"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			render :change_admin
		end 
	end

	def show
		@department = Department.find(params[:id])
	end

	def edit
		@department = Department.find(params[:id])
	end

	def update
		@department = Department.find(params[:id])

		@department.assign_attributes(department_params)
		
		if @department.save
			flash[:success] = "Department has been update successfully"
			redirect_to dashboard_index_path
		else
			flash[:error] = "An error occurred. Please try again."
			render :edit
		end
	end

	def destroy
		@department = Department.find(params[:id])
		@department.destroy
		flash[:success] = "Deleted successfully"
		redirect_to dashboard_index_path
	end


	private

	def department_params
	  	params.require(:department).permit(:id, :name, :image, :department_id)
	end
end
