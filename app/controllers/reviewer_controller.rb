class ReviewerController < ApplicationController

	def create
		@currentUser = current_user
		@review = Reviewer.new(review_params)
		@review.user_id = @currentUser.id
		@review.department_id = @currentUser.department_id
		
		if @review.save
			redirect_to dashboard_index_path,success: "Review added successfully."
		else
			redirect_to dashboard_index_path,error: "An error occured!"
		end
	end

	private

	def review_params
	  	params.require(:reviewer).permit(:post_id,:feedback)
	end
end
