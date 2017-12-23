class CreateUserPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_posts do |t|
      t.integer :user_id
      t.integer :department_id
      t.integer :post_type
      t.text :post_content
      t.integer :privacy
      t.integer :post_genre
      t.integer :edit_status
      t.integer :review_status

      t.timestamps
    end
  end
end
