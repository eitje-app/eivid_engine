class AddTitleToVideo < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_videos, :title, :string
  end
end
