# Eivid

Never stops streaming awesome videos, yay!

## Installation

Add the following to your application's Gemfile and run $bundle:

```ruby

gem 'eivid', git: 'https://github.com/eitje-app/eivid_engine', branch: 'production'

```
Or, for development purposes, add instead:

```ruby
local_eivid_path = "/Users/jurriaanschrofer/Documents/eivid"
if ENV["RAILS_ENV"] == 'development' && Dir.glob(local_eivid_path).any?
  gem 'eivid', path: local_eivid_path
else
  gem 'eivid', git: 'https://github.com/eitje-app/eivid_engine', branch: 'production'
end
```

Add the following file to your app's config/initializers directory:

```ruby

# eivid.rb

Eivid.set_mattr_accessors do |config|
  config.owner_model = "owner"
end

```

In this file, set the {owner_model} to your apps owner of videos, which generates the following methods (in this example config.owner_model is set to "organisation"):

```ruby

# retrieves the owner_id from a record
Eivid::Video.first.organisation_id

# returns the owner record of your application
Eivid::Video.first.organisation 

# scope, which returns all records for your application's organisation
Eivid::Video.of_organisation(id)

# returns the owner record of your application
Eivid::Owner.organisation

```

Witin your application's owner model (in this example Organisation), add to following:

```ruby

include Eivid::Concerns::MainApp::Owner

```

Which runs an after_create effect, which creates an Eivid::Owner for every new Organisation record, and generates the following methods within your application:

```ruby

# returns a single Eivid::Owner record for the owner, which includes a Vimeo folder_id
Organisation.first.eivid_owner

#returns all Eivid::Video records, which each contain an url to the video and vimeo_id
Organisation.first.eivid_videos

```

Besides an owner, an Eivid::Video can belongs to many resources of your main application, e.g. a Post, Manual or Message. This functionality is provided through a join table Eivid::VideoResource, which enables any model of your application to has_many Eivid::VideoResource. In order to create this association, paste the following code in your application's resource holder:

```ruby

include Eivid::Concerns::MainApp::VideoResource

```

Which generates the following methods within your application (in this example for a Post model):

```ruby

# returns join table records
Post.first.eivid_video_resources

# returns video records
Post.first.eivid_videos

# scope which returns all records (here Post instances) which have a video
Post.has_video

# scope which returns all records (here Post instances) which do not have a video
Post.has_not_video

```

Create and run the required migrations:

```bash

$ rails eivid:install:migrations
$ rails db:migrate

```

For your application's owner model (in this example Organisation), run the following command, which creates all dedicated folders within Vimeo:

```ruby

Organisation.find_each { |owner| Eivid::Owner.create(external_id: owner.id) }

```

Add the following to your routes.rb:

```ruby

mount Eivid::Engine => "/eivid"

```

Set the following environment variables in your application:

```ruby

VIMEO_ACCESS_TOKEN

```
