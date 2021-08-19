module Eivid::GetVimeoUrlsMixin
  extend ActiveSupport::Concern
  included do

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

  end
end