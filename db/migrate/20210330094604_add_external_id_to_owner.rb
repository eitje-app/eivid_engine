class AddExternalIdToOwner < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_owners, :external_id, :integer
  end
end
