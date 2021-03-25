module Eivid
  class UploadVimeoJob < ApplicationJob

    def perform(video_record:, video_file:)
      @video_record = video_record
      @video_file   = video_file
      
      upload_to_vimeo
      @video_url    = @video_upload["link"]

      update_record
      notify_front
      check_status
    end

    private

    def upload_to_vimeo      
      @vimeo_client = Eivid::RequestService.connect_user
      @video_upload = @vimeo_client.upload_video(@video_file)

    end

    def update_record
      return unless @video_url
      @video_record.update(url: @video_url, uploaded: true)
    end

    def notify_front
      # implement
    end

    def check_status
      CheckVimeoStatusJob.perform_later(video_record: @video_record)
    end

  end
end