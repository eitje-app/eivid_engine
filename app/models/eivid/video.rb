module Eivid
  class Video < ApplicationRecord

    def owner_id # required for aliassing
      super
    end

    alias_method :"#{Eivid.owner_model}_id", :owner_id
    belongs_to   :"#{Eivid.owner_model}", foreign_key: "owner_id"
    scope        :"of_#{Eivid.owner_model}", -> (owner_id) { where(owner_id: owner_id) }

  end
end