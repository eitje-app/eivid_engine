class CreateEividOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :eivid_owners do |t|

      t.timestamps
      
    end
  end
end
