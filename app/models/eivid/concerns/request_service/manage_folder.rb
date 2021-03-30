module Eivid::Concerns::RequestService::ManageFolder
  extend ActiveSupport::Concern
  
  def test
    binding.pry
    create_folder(org_id: 1)
  end

  def create_folder(org_id:)
    @folder_name = "org_#{org_id}"
    HTTParty.post Eivid::RequestService::FOLDER_URL, **create_folder_params
  end

  def create_folder_params
    body = {
      "name" => @folder_name
    }

    headers = {
      "Authorization" => "bearer #{Figaro.env.VIMEO_ACCESS_TOKEN}",
      "Content-Type"  => "application/json",
      "Accept"        => "application/vnd.vimeo.*+json;version=3.4" 
    }

    { body: body.to_json, headers: headers }
  end  
  
end