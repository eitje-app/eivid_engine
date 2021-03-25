class AddUploadedBoolToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_videos, :uploaded, :boolean, default: false
  end
end
