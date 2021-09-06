module Eivid::Concerns::MainApp::Owner
  extend ActiveSupport::Concern
  included do
  
    has_one  :video_owner, class_name: 'Eivid::Owner', foreign_key: 'external_id'
    has_many :videos, class_name: 'Eivid::Video', source: :video_owner, foreign_key: 'owner_id'

    include Eivid::Concerns::MainApp::VideoConcerns

    after_commit :create_eivid_owner, on: :create

    def create_eivid_owner
      Eivid::Owner.create(external_id: self.id)
    end
  
  end
end