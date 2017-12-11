class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :name,              null: false
      t.string :email,             null: false
      t.integer :member
      t.integer :status,		   null: false
      t.string :description,	   null: false, default: ""

      t.timestamps
    end
  end
end
