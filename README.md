Couch Factory
============

[![Build Status](https://travis-ci.org/javierg/couch_factory.png)](https://travis-ci.org/javierg/couch_factory)

Implementing [factory_girl](http://github.com/thoughtbot/factory_girl) in Elixir, with support for persisting documents into a couchdb server.

Sort of inspired by [factory girl elixir](https://github.com/sinetris/factory_girl_elixi), but with a different API.

## TODO

* Document public functions
* Add sequences
* Add properties (because the result is a list, it should be very simple)
* Figure it out how to actually override default configuration for couchdb
* handle conflicts when creating documents
* auto namespacing on document ids


## usage

You will need `couchdb` server up and running

```elixir
defp deps do
  [
    {:couch_factory, git: "git@github.com:javierg/couch_factory.git", branch: "master"}
  ]
end
```

Update the applications list to include both projects:

```elixir
def application do
  [applications: [:couch_factory]]
end
```

Run `mix deps.get` in your shell.


## Defining a Factory

```elixir
defmodule Factory do
  use CouchFactory.Factory

  factory :user,
    _id: "user/octavio@paz.com",
    name: "Octavio Paz",
    email: "octavio@paz.com"

end
```

On your tests now you can do

```elixir
test "will do something" do
  expected = {[{"_id", "user/octavio@paz.com"}, {"name", "Octavio Paz"}, {"email", "octavio@paz.com"}]}
  assert expected == Factory.build(:user)
end

test "this is persisted" do
  assert {:ok, user} = Factory.create(:user)
end

test "override properties" do
  expected = {[{"_id", "user/octavio@paz.com"}, {"name", "Octavio Paz"}, {"email", "octavio@war.com"}]}
  assert expected == Factory.build(:user, email: "octavio@war.com")
end
```

## Copyright and license

Copyright (c) 2014 Duilio Ruggiero. Code released under [the MIT license](LICENSE).
