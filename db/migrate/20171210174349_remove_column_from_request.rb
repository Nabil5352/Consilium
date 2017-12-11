class RemoveColumnFromRequest < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :department_id, :integer
  end
end
