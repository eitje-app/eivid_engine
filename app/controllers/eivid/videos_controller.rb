require_dependency "eivid/application_controller"

module Eivid
  class VideosController < ApplicationController

    def upload_video
      video_record = Video.create(owner_id: params["owner_id"])
      video_file   = params["video_file"]

      # in order to call perform_later instead of perform_now, I have to store the file in a temporary location
      # https://stackoverflow.com/questions/29136542/rails-actiondispatchhttpuploadedfile-in-background-job

      UploadVimeoJob.perform_now(video_record: video_record, video_file: video_file)
      render json: video_record
    end

  end
end
