class RemoveCoumnFromOrganizations < ActiveRecord::Migration[5.1]
  def change
    remove_column :organizations, :department_id, :integer
  end
end
