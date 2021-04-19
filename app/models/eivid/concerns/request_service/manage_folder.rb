module Eivid::Concerns::RequestService::ManageFolder
  extend ActiveSupport::Concern
  
  def get_all_folders
    HTTParty.get Eivid::RequestService::FOLDER_URL, headers: default_headers
  end

  def create_folder(namespace:, id:)
    body = { "name" => "#{Rails.env}_#{namespace}_#{id}" }
    
    @response = HTTParty.post Eivid::RequestService::FOLDER_URL, body: body.to_json, headers: default_headers
    get_folder_id
  end

  def add_video_to_folder(video_record:)
    video_id  = video_record.vimeo_id
    folder_id = video_record.owner.folder_id
    endpoint  = Eivid::RequestService::ADD_TO_FOLDER_URL.call(folder_id, video_id)
    
    HTTParty.put endpoint, headers: default_headers
  end

  private

  def get_folder_id
    @response["uri"].split('/').last
  end
  
end