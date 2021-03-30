module Eivid
  class ApplicationController < ActionController::API

    private

    def find_owner(external_owner_id)
      Owner.find_by(external_id: params["external_owner_id"]) || report_record_not_found
    end

    def report_record_not_found
      raise MainAppRecordNotFoundError.new 
      "the given external_owner_id could not be mapped to your application's owner records"
    end

  end
end
