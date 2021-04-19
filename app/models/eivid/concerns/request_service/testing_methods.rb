module Eivid::Concerns::RequestService::TestingMethods
  extend ActiveSupport::Concern

    def delete_all_videos
      puts "are you sure you want to delete ALL videos from Vimeo? Confirm by typing: 'yup brah'"
      confirmation = gets
      return "operation cancelled" unless confirmation.chomp == "yup brah"
      delete_all_videos_from_vimeo
    end

    private

    def get_all_video_ids
      get_all_pages.map { |page| get_single_page_video_ids(page) }.flatten
    end

    def delete_all_videos_from_vimeo
      get_all_video_ids.map { |id| delete_single_video_from_vimeo(id) }
    end

    def delete_single_video_from_vimeo(vimeo_id)
      HTTParty.delete "#{Eivid::RequestService::PLAIN_VIDEO_URL}/#{vimeo_id}", headers: default_headers
      puts "deleted #{vimeo_id}"
    end

    def get_single_page_video_ids(url)
      response = HTTParty.get url, headers: default_headers
      JSON.parse(response)["data"].map { |record| record["link"].split('/').last }
    end

    def get_all_pages
      response   = HTTParty.get Eivid::RequestService::VIDEOS_URL, headers: default_headers
      page_count = (JSON.parse(response)["total"] / 25.to_f).ceil

      (1..page_count).map { |cnt| "#{Eivid::RequestService::VIDEOS_URL}?page=#{cnt}" }
    end

end