class CreateEividVideoResources < ActiveRecord::Migration[5.2]
  def change
    create_table :eivid_video_resources do |t|

      t.timestamps
      t.integer :video_id
      t.integer :resource_id
      t.string :resource_type

    end
  end
end
