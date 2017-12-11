class AddColumnToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :requested_at, :datetime
  end
end
