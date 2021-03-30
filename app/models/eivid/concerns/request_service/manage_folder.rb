module Eivid::Concerns::RequestService::ManageFolder
  extend ActiveSupport::Concern
  
  def get_all_folders
    HTTParty.get Eivid::RequestService::FOLDER_URL, headers: get_headers
  end

  def create_folder(namespace:, id:)
    body = { "name" => "#{namespace}_#{id}" }
    
    @response = HTTParty.post Eivid::RequestService::FOLDER_URL, body: body.to_json, headers: get_headers
    get_folder_id
  end

  def add_video_to_folder(video_record:)
    video_id  = video_record.vimeo_id
    folder_id = video_record.owner.folder_id
    endpoint  = Eivid::RequestService::ADD_TO_FOLDER_URL.call(folder_id, video_id)
    
    HTTParty.put endpoint, headers: get_headers
  end

  private

  def get_folder_id
    @response["uri"].split('/').last
  end

  def get_headers
    {
      "Authorization" => "bearer #{Figaro.env.VIMEO_ACCESS_TOKEN}",
      "Content-Type"  => "application/json",
      "Accept"        => "application/vnd.vimeo.*+json;version=3.4" 
    }
  end
  
end