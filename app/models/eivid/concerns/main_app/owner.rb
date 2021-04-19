module Eivid::Concerns::MainApp::Owner
  extend ActiveSupport::Concern
  included do
  
    has_one  :video_owner, class_name: 'Eivid::Owner', foreign_key: 'external_id'
    has_many :videos,      class_name: 'Eivid::Video', source: :video_owner, foreign_key: 'owner_id'

    after_create :create_eivid_owner

    def create_eivid_owner
      Eivid::Owner.create(external_id: self.id)
    end
  
  end
end