module Eivid
  class Owner < ApplicationRecord

    has_many :videos

    belongs_to :"#{Eivid.owner_model}", foreign_key: "external_id"

    def external_owner
      send Eivid.owner_model
    end

  end
end
