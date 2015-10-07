defmodule CouchFactoryTest do
  use ExUnit.Case
  Code.require_file("support/factory.exs", __DIR__)

  test "calling factory function returns map" do
    expected = [_id: "user/foo@bar.com", name: "Foo Bar", email: "foo@bar.com"]
    assert Factory.user == expected
  end

  test "build will return expected list" do
    expected = {[{"_id", "user/foo@bar.com"}, {"name", "Foo Bar"}, {"email", "foo@bar.com"}]}
    assert Factory.build(:user) == expected
  end

  test "override values on build" do
    expected = {[{"_id", "user/ricardo@fmagon.com"}, {"name", "Ricardo Flores Magón"}, {"email", "ricardo@fmagon.com"}]}
    built = Factory.build(:user, _id: "user/ricardo@fmagon.com", name: "Ricardo Flores Magón", email: "ricardo@fmagon.com")
    assert expected == built
  end

  #TODO: Do couchdb tests.
  # should We mock the http couch requests?
  # or do we set as a requirenment an actual
  # couchdb server running for tests?
end
