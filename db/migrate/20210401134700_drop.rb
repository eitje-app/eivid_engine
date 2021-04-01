class Drop < ActiveRecord::Migration[5.2]
  def change
    drop_table :eivid_dev_envs
  end
end
