defmodule CouchFactoryTest do
  defmodule BuildTest do
    use ExUnit.Case

    @map_user [_id: "user/foo@bar.com", name: "Foo Bar", email: "foo@bar.com"]
    @doc_user {[{"_id", "user/foo@bar.com"}, {"name", "Foo Bar"}, {"email", "foo@bar.com"}]}

    test "calling factory function returns map" do
      assert Factory.user == @map_user
    end

    test "build will return expected list" do
      assert Factory.build(:user) == @doc_user
    end

    test "override values on build" do
      expected = {[{"_id", "user/ricardo@fmagon.com"}, {"name", "Ricardo Flores Magón"}, {"email", "ricardo@fmagon.com"}]}
      built = Factory.build(:user, _id: "user/ricardo@fmagon.com", name: "Ricardo Flores Magón", email: "ricardo@fmagon.com")
      assert expected == built
    end

    test "calling unexisting factory" do
      assert {:error, :missing_factory} == Factory.build(:santa)
    end
  end

  defmodule CreateTest do
    alias CouchFactory.Db, as: Couch
    use ExUnit.Case

    setup do
      {:ok, user} = Factory.create(:user)
      on_exit fn-> Couch.destroy(user) end
      {:ok, [user: user]}
    end

    test "user is persisted", %{user: user} do
      doc_id = Couch.value(user, "_id")
      assert {:ok, user} == Couch.get(doc_id)
    end

    test "override default values for new doc", %{user: user} do
      new_user_id = "user/ricardo@fmagon.com"
      new_name   = "Ricardo Flores Magón"

      assert {:ok, new_user} = Factory.create(:user, _id: new_user_id, name: new_name)
      assert new_user_id == Couch.value(new_user, "_id")
      assert new_name == Couch.value(new_user, "name")
      assert Couch.value(new_user, "email") == Couch.value(user, "email")

      assert Couch.destroy(new_user)
    end

    test "trying to create unexisting factory" do
      assert {:error, :missing_factory} == Factory.create(:santa)
    end
  end

  defmodule PropertiesTest do
    use ExUnit.Case

    test "returns properties map" do
      expected = %{_id: "user/foo@bar.com", name: "Foo Bar", email: "foo@bar.com"}
      assert Factory.properties_for(:user) == expected
    end

    test "can override properties" do
      expected = %{_id: "user/foo@bar.com", name: "Another name", email: "foo@bar.com"}
      assert Factory.properties_for(:user, name: "Another name") == expected
    end

    test "properties_for missing factory" do
      assert {:error, :missing_factory} == Factory.properties_for(:santa)
    end
  end

end
