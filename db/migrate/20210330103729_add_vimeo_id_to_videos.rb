class AddVimeoIdToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_videos, :vimeo_id, :string
  end
end
