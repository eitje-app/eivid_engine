module Eivid
  class GetVimeoUrlsJob < ApplicationJob

    retry_on VideoUrlsUnavailableError, wait: 10.seconds, attempts: 50

    def perform(video_record:, vimeo_id:)
      @video_record = video_record
      @vimeo_id     = vimeo_id

      set_response
      set_url_sd
      set_url_hd
      set_url_thumbnail
      
      validate_url_presence
      validate_url_thumbnail

      update_record
      notify_front
    end

    private

    def set_response
      @response = Eivid::RequestService.get_video @vimeo_id
    end

    def set_url_sd
      @url_sd = dig_video_url :sd
    end

    def set_url_hd
      @url_hd = dig_video_url :hd
    end

    def dig_video_url(definition)
      @response[:files]&.find { |video| video[:quality] == definition.to_s }&.dig(:link)
    end

    def set_url_thumbnail
      @url_thumbnail = find_high_res_thumbnail || find_low_res_thumbnail
    end

    def find_high_res_thumbnail
      @response&.dig(:pictures, :sizes)&.find { |url| url[:width] == 960 && url[:height] == 540 }&.dig(:link_with_play_button)
    end

    def find_low_res_thumbnail
      @response&.dig(:pictures, :sizes)&.find { |url| url[:width] == 640 && url[:height] == 360 }&.dig(:link_with_play_button)
    end

    def validate_url_presence
      raise Eivid::VideoUrlsUnavailableError unless @url_thumbnail
    end

    def validate_url_thumbnail
      raise Eivid::VideoUrlsUnavailableError if @url_thumbnail.include? 'video%2Fdefault'
    end

    def update_record
      @video_record.update(uploaded: true, url_sd: @url_sd, url_hd: @url_hd, url_thumbnail: @url_thumbnail)
    end

    def notify_front
      data = { video: @video_record.slice(:id, :user_id), progress: { percentage: 100, step: "All video versions are available on Vimeo." } }
      NotifyFrontService.progress('notify_method_on_versions_available', data)
    end

  end
end
