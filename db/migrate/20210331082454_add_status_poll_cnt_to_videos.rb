class AddStatusPollCntToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_videos, :status_poll_cnt, :integer, default: 0
  end
end
