module Eivid
  class ApplicationController < ActionController::API

    def find_owner(external_owner_id)
      Owner.find_by(external_id: params["external_owner_id"]) || raise("owner_not_found")
    end

  end
end
