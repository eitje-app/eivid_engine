module Eivid
  class ApplicationController < ActionController::API

    include Concerns::VideoValidations

    private

    def set_owner
      @owner = Owner.find_by(external_id: params["external_owner_id"]) || report_record_not_found
    end

    def report_record_not_found
      raise MainAppRecordNotFoundError.new( 
        "the given external_owner_id could not be mapped to your application's owner records"
      )
    end

  end
end
