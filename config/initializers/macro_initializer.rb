module Eivid::Macros
  extend ActiveSupport::Concern
  included do
    class << self

      def eivid_owner
        include Eivid::Concerns::MainApp::Owner
      end

      def eivid_video_resource
        include Eivid::Concerns::MainApp::VideoResource
      end

      def eivid_user
        include Eivid::Concerns::MainApp::User
      end

    end
  end
end

::ActiveRecord::Base.send :include, Eivid::Macros