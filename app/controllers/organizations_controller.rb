class OrganizationsController < ApplicationController

	before_action :org_super_admin_only!, only: [:edit, :update, :destroy]

	def new
		@organization = Organization.new
	end

	def create
		@currentUser = current_user.id
		@organization = Organization.new(organization_params)
		@organization.super_admin = @currentUser
		
		if @organization.save
			redirect_to dashboard_index_path,success: "Request successfull! A reviewer will review and notify you soon."
		else
			render :new
		end
	end

	def show
		@organization = Organization.find(params[:id])
		@currentUser = current_user;
		@departments = Department.all.where(organization_id: @organization.id)
	end

	def edit
		@organization = Organization.find(params[:id])
	end

	def update
		@organization = Organization.find(params[:id])
	end

	def destroy
		@organization = Organization.find(params[:id])
	end


	private

	def organization_params
	  	params.require(:organization).permit(:id,:name, :email)
	end
end
