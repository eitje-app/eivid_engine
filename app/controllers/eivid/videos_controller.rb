require_dependency "eivid/application_controller"
require 'tempfile'

module Eivid
  class VideosController < ApplicationController

    # for local development, run: 
      # QUEUE=* rake resque:work
      # rake environment resque:scheduler

    def upload_video
      owner  = find_owner params["external_owner_id"]     
      record = UploadService.upload(owner: owner, video_file: params["video_file"])   
      render json: record
    end

    def owner_videos
      owner = find_owner params["external_owner_id"]   
      render json: owner.videos
    end

  end
end