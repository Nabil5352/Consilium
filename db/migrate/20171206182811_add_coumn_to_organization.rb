class AddCoumnToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :department_id, :integer
  end
end
