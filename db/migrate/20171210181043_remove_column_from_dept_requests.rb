class RemoveColumnFromDeptRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :dept_requests, :org_id, :integer
  end
end
