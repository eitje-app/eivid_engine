class RemoveStatusPollCntFromEividVideos < ActiveRecord::Migration[5.2]
  def change
    remove_column :eivid_videos, :status_poll_cnt
  end
end
