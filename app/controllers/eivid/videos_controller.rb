require_dependency "eivid/application_controller"
require 'tempfile'

# for local development, run: 
  # QUEUE=* rake resque:work
  # rake environment resque:scheduler

module Eivid
  class VideosController < ApplicationController

    before_action :set_owner, only: [:upload_video, :owner_videos]

    def upload_video
      record = UploadService.upload(owner: @owner, video_file: video_params["video_file"])   
      render json: record
    end

    def owner_videos
      render json: @owner.videos
    end

    private

    def set_owner
      @owner = find_owner params["external_owner_id"]
    end

    def video_params
      params.permit("video_file")
    end

  end
end