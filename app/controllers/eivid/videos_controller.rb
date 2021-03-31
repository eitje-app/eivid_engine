require_dependency "eivid/application_controller"
require 'tempfile'

# for local development, run: 
  # QUEUE=* rake resque:work
  # rake environment resque:scheduler

module Eivid
  class VideosController < ApplicationController

    before_action :set_owner, only: [:upload_video, :owner_videos]
    before_action :set_video, only: [:show, :destroy]
    before_action :validate_video_file, only: [:upload_video]

    def upload_video
      record = UploadService.upload(owner: @owner, video_file: video_params["video_file"])   
      render json: record
    end

    def owner_videos
      render json: @owner.videos
    end

    def index
      render json: Video.all
    end

    def show
      render json: @video
    end

    def destroy
      record = RequestService.destroy(video: @video)
      render json: record
    end

    private

    def set_video
      @video = Video.find params["id"]
    end

    def video_params
      params.permit("video_file")
    end

  end
end