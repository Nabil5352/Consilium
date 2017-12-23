json.extract! user_post, :id, :user_id, :department_id, :post_type, :post_content, :privacy, :post_genre, :edit_status, :review_status, :created_at, :updated_at
json.url user_post_url(user_post, format: :json)
