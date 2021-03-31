module Eivid
  class UploadVimeoJob < ApplicationJob

    def perform(video_record:, video_path:)
      log_perform

      @video_record = video_record
      @video_path   = video_path # temp
      @video_file   = File.open(video_path).read

      upload_to_vimeo
      @vimeo_url = @response.dig(:link)
      @vimeo_id  = @vimeo_url.split('/').last

      update_record
      add_to_folder
      notify_front
      check_status
    end

    private

    def upload_to_vimeo      
      @response = Eivid::RequestService.upload_video(video_path: @video_path)
    end

    def update_record
      @video_record.update(url: @vimeo_url, vimeo_id: @vimeo_id)
    end

    def notify_front
      # implement
    end

    def add_to_folder
      Eivid::RequestService.add_video_to_folder(video_record: @video_record)
    end

    def check_status
      CheckVimeoStatusJob.perform_now(video_record: @video_record)
    end

    def log_perform
      # logger = Logger.new "log/test_upload_job_#{Time.now.strftime("%T")}.log"
      # logger.debug "yay, UploadVimeoJob ran!"
    end 

  end
end
