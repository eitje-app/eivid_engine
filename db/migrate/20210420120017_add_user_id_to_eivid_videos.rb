class AddUserIdToEividVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_videos, :user_id, :integer
  end
end
