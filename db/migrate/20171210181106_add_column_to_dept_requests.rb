class AddColumnToDeptRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :dept_requests, :department_id, :integer
  end
end
