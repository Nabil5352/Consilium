class UserPostsController < ApplicationController

  def create
    @currentUser = current_user
    @user_post = UserPost.new(user_post_params)
    @user_post.user_id = current_user.id
    @user_post.department_id = current_user.department_id
    
    if @user_post.save
      flash[:success] = "Posted successfully."
      redirect_to dashboard_index_path
    else
      flash[:error] = "An error occurred. Please try again."
      redirect_to dashboard_index_path
    end
  end

  def update
    if @user_post.update
      flash[:success] = "Updated successfully."
      redirect_to dashboard_index_path
    else
      flash[:error] = "An error occurred. Please try again."
      redirect_to dashboard_index_path
    end
  end

  def destroy
    @user_post = UserPost.find(params[:id])
    @user_post.destroy

    flash[:success] = "Post deleted successfully."
    redirect_to dashboard_index_path
  end

  private

    def user_post_params
      params.require(:user_post).permit(:user_id, :document, :department_id, :post_type, :post_content, :privacy, :post_genre, :edit_status, :review_status)
    end
end
