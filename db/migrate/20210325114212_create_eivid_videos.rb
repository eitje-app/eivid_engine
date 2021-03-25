class CreateEividVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :eivid_videos do |t|

      t.timestamps
      t.integer :owner_id
      t.string :url

    end
  end
end
