class AddFolderIdToOwner < ActiveRecord::Migration[5.2]
  def change
    add_column :eivid_owners, :folder_id, :string
  end
end
