class ChangeUrlToEmbeddedUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :eivid_videos, :url, :url_embedded
  end
end
