module Eivid
  class RequestFolderIdJob < ApplicationJob

    def perform(eivid_owner_id)

      owner     = Owner.find(eivid_owner_id) 
      folder_id = RequestService.create_folder(namespace: Eivid.owner_model, id: owner.id)

      owner.update!(folder_id: folder_id)

    end

  end
end