require_dependency "eivid/application_controller"

module Eivid
  class VideosController < ApplicationController

    def upload_video
      video_record = Video.create(owner_id: params["owner_id"])
      video_file   = params["video_file"]

      UploadVimeoJob.perform_now(video_record: video_record, video_file: video_file)
      render json: video_record
    end

  end
end
