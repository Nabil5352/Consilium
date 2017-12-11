class AddAttachmentImageToDepartments < ActiveRecord::Migration[5.1]
  def self.up
    change_table :departments do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :departments, :image
  end
end
