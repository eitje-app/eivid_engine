module Eivid::Concerns::RequestService::ManageFolder
  extend ActiveSupport::Concern
  
  def test
    binding.pry
  end

  def get_all_folders
    HTTParty.get Eivid::RequestService::FOLDER_URL, headers: folder_headers
  end

  def create_folder(namespace: "org", id:)
    body = {
      "name" => "#{namespace}_#{org_id}"
    }
    HTTParty.post Eivid::RequestService::FOLDER_URL, body: body, headers: folder_headers
  end

  private

  def folder_headers
    headers = {
      "Authorization" => "bearer #{Figaro.env.VIMEO_ACCESS_TOKEN}",
      "Content-Type"  => "application/json",
      "Accept"        => "application/vnd.vimeo.*+json;version=3.4" 
    }
  end
  
end