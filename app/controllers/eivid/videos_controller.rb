require_dependency "eivid/application_controller"
require 'tempfile'

module Eivid
  class VideosController < ApplicationController

    def upload_video
      video_record = Video.create(owner_id: params["owner_id"])
      video_file   = params["video_file"]

      file_name, file_ext = video_file.original_filename.split('.') 
      temp_file = Tempfile.new([file_name, ".#{file_ext.downcase}"], "#{Rails.root}/tmp/")
      
      temp_file << video_file.tempfile.open.read
      temp_path = temp_file.path
      temp_file.close

      UploadVimeoJob.perform_now(video_record: video_record, video_path: temp_path)
      render json: video_record
    end

  end
end

      # # legacy through CarrierWave
      # video = VideoUploader.new
      # video.store!(video_file)
      # temp_path = video.file.file