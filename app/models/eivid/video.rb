module Eivid
  class Video < ApplicationRecord

    belongs_to :owner
    belongs_to :user, optional: true
    has_many   :video_resources

    def owner_id # required for aliassing :owner_id
      super
    end

    def external_owner
      owner.send Eivid.owner_model
    end

    alias_method :"#{Eivid.owner_model}_id", :owner_id
    alias_method :"#{Eivid.owner_model}", :external_owner
    scope        :"of_#{Eivid.owner_model}", -> (owner_id) { where(owner_id: owner_id) }

  end
end