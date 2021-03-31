# Eivid

Never stops streaming awesome videos, yay!

## Installation

Add the following to your application's Gemfile and run bundle install:

```ruby

gem 'eivid', git: 'https://github.com/eitje-app/eivid_engine', branch: 'production'

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

has_one  :eivid_owner,  class_name: 'Eivid::Owner', foreign_key: 'external_id'
has_many :eivid_videos, class_name: 'Eivid::Video', source: :eivid_owner, foreign_key: 'owner_id'

after_create :create_eivid_owner

def create_eivid_owner
	Eivid::Owner.create(external_id: self.id)
end

```

Which generates the following methods within your application:

```ruby

# returns a single Eivid::Owner record for the owner, which includes a Vimeo folder_id
Organisation.first.eivid_owner

#returns all Eivid::Video records, which each contain an url to the video and vimeo_id
Organisation.first.eivid_videos

```

For your application's owner model (in this example Organisation), run the following command, which creates all dedicated folders within Vimeo:

```ruby

Organisation.find_each { |owner| Eivid::Owner.create(external_id: owner.id) }

```

Create and run the required migrations:

```bash

$ rails eivid:install:migrations
$ rails db:migrate

```
Add the following to your routes.rb:
```ruby

mount Eivid::Engine => "/eivid"

```
Set the following environment variables in your application:
```ruby

VIMEO_ACCESS_TOKEN

```
