module Eivid
  class UploadVimeoJob < ApplicationJob

    def perform(video_record:, video_path:)
      @video_record = video_record
      @video_path   = video_path # temp
      @video_file   = File.open(video_path).read

      # binding.pry
      # return

      upload_to_vimeo
      @video_url    = @video_upload["link"]

      update_record
      notify_front
      check_status
    end

    private

    # # wrapper method
    # def upload_to_vimeo      
    #   @vimeo_client = Eivid::RequestService.connect_user
    #   @video_upload = @vimeo_client.upload_video(@video_file)
    # end

    #custom method
    def upload_to_vimeo      
      response = Eivid::RequestService.upload_video(video_path: @video_path)
      return
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
