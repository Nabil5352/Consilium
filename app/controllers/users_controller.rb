class UsersController < ApplicationController

	def index
		@users = User.all.where.not(role: 0)
	end

	def show
		@user = User.find(params[:id])
	end

	def destroy
		users = User.find(params[:id])
		user.destroy
		redirect_to users_path, :notice => "User deleted"
	end
end
