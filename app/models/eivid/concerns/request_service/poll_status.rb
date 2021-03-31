module Eivid::Concerns::RequestService::PollStatus
  extend ActiveSupport::Concern

  def get_status(vimeo_id:)
    client = connect_general
    client.get "#{Eivid::RequestService::BASE_URL}/videos/#{vimeo_id}?fields=uri,status"
  end
  
end