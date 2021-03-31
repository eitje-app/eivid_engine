module Eivid::Concerns::RequestService::PollStatus
  extend ActiveSupport::Concern

  def get_status(vimeo_id:)
    response = HTTParty.get "#{Eivid::RequestService::BASE_URL}/videos/#{vimeo_id}?fields=uri,status", headers: default_headers
    JSON.parse(response)
  end
  
end