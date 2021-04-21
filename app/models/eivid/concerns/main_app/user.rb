module Eivid::Concerns::MainApp::User
  extend ActiveSupport::Concern
  included do
  
    has_many :videos, class_name: 'Eivid::Video'
    has_many :video_resources, class_name: 'Eivid::VideoResource', through: :videos

    include Eivid::Concerns::MainApp::VideoConcerns
    
  end
end