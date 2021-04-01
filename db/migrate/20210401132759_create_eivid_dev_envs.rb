class CreateEividDevEnvs < ActiveRecord::Migration[5.2]
  def change
    create_table :eivid_dev_envs do |t|

      t.timestamps
      t.string :env
      t.string :folder_id

    end
  end
end
