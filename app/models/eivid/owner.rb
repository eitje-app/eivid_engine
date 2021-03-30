module Eivid
  class Owner < ApplicationRecord

    has_many :videos

    validates :external_id, presence: true #, uniqueness: true # comment out for dev only

    before_create :get_folder_id

    belongs_to :"#{Eivid.owner_model}", foreign_key: "external_id"

    def external_owner
      send Eivid.owner_model
    end

    def get_folder_id
      self.folder_id = RequestService.create_folder(namespace: Eivid.owner_model, id: self.external_id)
    end

  end
end
