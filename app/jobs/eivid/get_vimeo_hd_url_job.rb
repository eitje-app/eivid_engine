module Eivid
  class GetVimeoHdUrlJob < ApplicationJob

    include Eivid::GetVimeoUrlsMixin

    def perform(video_record:, vimeo_id:)
      @video_record = video_record
      @vimeo_id     = vimeo_id

      set_response
      set_url_hd

      return unless @url_hd
      update_record
    end

    private

    def update_record
      @video_record.update(url_hd: @url_hd)
    end

  end
end
