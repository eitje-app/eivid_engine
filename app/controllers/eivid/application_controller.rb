module Eivid
  class ApplicationController < ActionController::API

    include Concerns::VideoValidations

    private

    def set_owner
      @owner = Owner.find_by(external_id: eval(Eivid.infer_external_owner_id)) || report_record_not_found
    end

    def report_record_not_found
      raise MainAppRecordNotFoundError.new( 
        "The given external_owner_id could not be mapped to your application's owner records. 
        Beware: if you have overwritten the Eivid.infer_external_owner_id setting, the error is dependant on your main application."
      )
    end

  end
end
