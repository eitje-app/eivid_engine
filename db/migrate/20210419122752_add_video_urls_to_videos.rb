class AddVideoUrlsToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_videos, :url_sd, :string
    add_column :eivid_videos, :url_hd, :string
    add_column :eivid_videos, :url_thumbnail, :string
  end
end
