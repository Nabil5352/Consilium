class Editor < ActiveRecord::Migration[5.1]
  def change
  	create_table :editors do |t|
      t.integer :user_id
      t.integer :department_id
      t.integer :post_id
      t.text :comment

      t.timestamps
    end
  end
end
