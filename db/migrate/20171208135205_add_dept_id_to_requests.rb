class AddDeptIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :department_id, :integer
  end
end
