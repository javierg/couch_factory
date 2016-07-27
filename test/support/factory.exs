defmodule Factory do
  use CouchFactory.Factory

  factory :user,
    _id: "user/foo@bar.com",
    name: "Foo Bar",
    email: "foo@bar.com"

  factory :sequential_user_id,
    _id: sequence(fn(n)-> "user/foo_#{n}@bar.com" end),
    name: sequence(fn(n)-> "Name #{n}" end),
    email: sequence(fn(n)-> "foo_#{n}@bar.com" end),
    counter: sequence
end
