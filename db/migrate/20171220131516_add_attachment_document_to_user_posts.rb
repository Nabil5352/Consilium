class AddAttachmentDocumentToUserPosts < ActiveRecord::Migration[5.1]
  def self.up
    change_table :user_posts do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :user_posts, :document
  end
end
