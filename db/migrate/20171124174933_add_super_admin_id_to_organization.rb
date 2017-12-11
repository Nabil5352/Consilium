class AddSuperAdminIdToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :super_admin, :integer
  end
end
