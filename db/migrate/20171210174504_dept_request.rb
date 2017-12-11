class DeptRequest < ActiveRecord::Migration[5.1]
  create_table :dept_requests do |t|
      t.integer :user_id
      t.integer :org_id
      t.integer :status
      t.datetime :requests
    end
end
