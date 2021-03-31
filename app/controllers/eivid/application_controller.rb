module Eivid
  class ApplicationController < ActionController::API

    MAX_MB_VIDEO = 100

    private

    def set_owner
      @owner = Owner.find_by(external_id: params["external_owner_id"]) || report_record_not_found
    end

    def report_record_not_found
      raise MainAppRecordNotFoundError.new( 
        "the given external_owner_id could not be mapped to your application's owner records"
      )
    end

    def validate_video_file
      validate_video_file_format
      validate_video_file_size
    end

    def validate_video_file_format
      mime = params["video_file"]&.original_filename&.split('.')&.last&.downcase     
      unless Eivid::VideoMimeDump::DATA.include?(mime)
        raise Eivid::IncorrectVideoMimeTypeError.new(
          "the 'video_file' you tried to upload, is of an invalid mime type"
        )
      end
    end

    def validate_video_file_size
      megabytes = params["video_file"].tempfile.size / 1.0.megabyte
      unless MAX_MB_VIDEO >= megabytes
        raise VideoFileSizeTooBigError.new(
          "the 'video_file' size (#{megabytes.round(2)} mb) you tried to upload exceeds the maximum file size (#{MAX_MB_VIDEO} mb)"
        )
      end
    end

  end
end
