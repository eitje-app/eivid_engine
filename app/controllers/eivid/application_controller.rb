module Eivid
  class ApplicationController < ActionController::API

    private

    def set_owner
      @owner = Owner.find_by(external_id: params["external_owner_id"]) || report_record_not_found
    end

    def self.report_record_not_found
      raise MainAppRecordNotFoundError.new( 
        "the given external_owner_id could not be mapped to your application's owner records"
      )
    end

    def validate_video_file_format
      mime = params["video_file"].original_filename.split('.').last.downcase     
      unless Eivid::VideoMimeDump::DATA.include?(mime)
        raise Eivid::IncorrectVideoMimeTypeError.new(
          "the video file you tried to upload, is of an invalid mime type"
        )
      end
    end

  end
end
