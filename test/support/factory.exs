defmodule Factory do
  use CouchFactory.Factory

  factory :user,
    _id: "user/foo@bar.com",
    name: "Foo Bar",
    email: "foo@bar.com"

end
