module Eivid
  class Owner < ApplicationRecord

    has_many :videos

    validates :external_id, presence: true, uniqueness: true

    after_commit :get_folder_id, unless: :folder_id

    belongs_to :"#{Eivid.owner_model}", foreign_key: "external_id", optional: true

    def external_owner
      send Eivid.owner_model
    end

    def get_folder_id
      RequestFolderIdJob.perform_later(self.id)
    end

  end
end
