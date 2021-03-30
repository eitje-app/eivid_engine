module Eivid::Concerns::RequestService::ManageFolder
  extend ActiveSupport::Concern
  
  def test
    binding.pry
  end

  def get_all_folders
    HTTParty.get Eivid::RequestService::FOLDER_URL, headers: folder_headers
  end

  def create_folder(namespace:, id:)
    body = { "name" => "#{namespace}_#{id}" }
    
    @response = HTTParty.post Eivid::RequestService::FOLDER_URL, body: body.to_json, headers: folder_headers
    get_folder_id
  end

  private

  def get_folder_id
    @response["uri"].split('/').last
  end

  def folder_headers
    {
      "Authorization" => "bearer #{Figaro.env.VIMEO_ACCESS_TOKEN}",
      "Content-Type"  => "application/json",
      "Accept"        => "application/vnd.vimeo.*+json;version=3.4" 
    }
  end
  
end