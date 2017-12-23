class Reviewer < ActiveRecord::Migration[5.1]
  def change
  	create_table :reviewers do |t|
      t.integer :user_id
      t.integer :department_id
      t.integer :post_id
      t.text :feedback

      t.timestamps
    end
  end
end
