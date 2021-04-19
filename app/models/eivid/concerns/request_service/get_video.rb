module Eivid::Concerns::RequestService::GetVideo
  extend ActiveSupport::Concern

  def get_video(vimeo_id)
    response = HTTParty.get "#{Eivid::RequestService::PLAIN_VIDEO_URL}/#{vimeo_id}", headers: default_headers
    JSON.parse(response.body).deep_symbolize_keys
  end

end