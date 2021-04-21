ApplicationRecord.define_singleton_method :eivid_owner do
  include Eivid::Concerns::MainApp::Owner
end

ApplicationRecord.define_singleton_method :eivid_video_resource do
  include Eivid::Concerns::MainApp::VideoResource
end

ApplicationRecord.define_singleton_method :eivid_user do
  include Eivid::Concerns::MainApp::User
end