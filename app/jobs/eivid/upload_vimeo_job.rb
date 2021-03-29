module Eivid
  class UploadVimeoJob < ApplicationJob

    def perform(video_record:, video_path:)
      @video_record = video_record
      @video_path   = video_path # temp
      @video_file   = File.open(video_path).read

      upload_to_vimeo
      @video_url = @response.dig(:link)

      update_record
      notify_front
      check_status
    end

    private

    def upload_to_vimeo      
      @response = Eivid::RequestService.upload_video(video_path: @video_path)
    end

    def update_record
      return unless @video_url
      @video_record.update(url: @video_url)
    end

    def notify_front
      # implement
    end

    def check_status
      CheckVimeoStatusJob.perform_later(video_record: @video_record)
    end

  end
end
