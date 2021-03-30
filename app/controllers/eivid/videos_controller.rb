require_dependency "eivid/application_controller"
require 'tempfile'

module Eivid
  class VideosController < ApplicationController

    # for local development, run: 
      # QUEUE=* rake resque:work
      # rake environment resque:scheduler

    def upload_video
      video_record = Video.create(owner_id: params["owner_id"])
      video_file   = params["video_file"]

      file_name, file_ext = video_file.original_filename.split('.') 
      temp_file = Tempfile.new([file_name, ".#{file_ext.downcase}"], "#{Rails.root}/tmp/")
      
      temp_file << video_file.tempfile.open.read
      temp_path = temp_file.path
      temp_file.close

      UploadVimeoJob.perform_later(video_record: video_record, video_path: temp_path)
      render json: video_record
    end

  end
end