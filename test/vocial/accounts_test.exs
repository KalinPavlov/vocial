defmodule Vocial.AccountsTest do
  use Vocial.DataCase

  alias Vocial.Accounts
  alias Vocial.Accounts.User

  describe "users" do
    @valid_attrs %{
      username: "test",
      email: "test@test.com",
      active: true,
      password: "test",
      password_confirmation: "test"
    }

    @update_attrs %{
      active: false,
      email: "some@updated.email",
      encrypted_password: "some updated encrypted_password",
      username: "someupdated"
    }
    @invalid_attrs %{active: nil, email: nil, encrypted_password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      with create_attrs <- Enum.into(attrs, @valid_attrs),
           {:ok, user} <- Accounts.create_user(create_attrs) do
        Map.merge(user, %{password: nil, password_confirmation: nil})
      else
        error -> error
      end
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "new_user/0 returns a blank changeset" do
      changeset = Accounts.new_user()
      assert changeset.__struct__ == Ecto.Changeset
    end

    test "create_user/1 with valid data creates a user" do
      before = Accounts.list_users()
      user = user_fixture()
      updated = Accounts.list_users()

      refute Enum.any?(before, fn u -> user == u end)
      assert Enum.any?(updated, fn u -> user == u end)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 fails to create the user without the password and password_confirmation" do
      {:error, changeset} = user_fixture(%{password: nil, password_confirmation: nil})
      refute changeset.valid?
    end

    test "create_user/1 fails to create the user when the password and password_confirmation don't match" do
      {:error, changeset} = user_fixture(%{password: "test", password_confirmation: "fail"})
      refute changeset.valid?
    end

    test "create_user/1 fails to create user when the username already exists" do
      user_fixture()
      {:error, changeset} = user_fixture()

      refute changeset.valid?
    end

    test "create_user/1 fails to create user when the email is not with valid format" do
      {:error, changeset} = user_fixture(%{email: "fail"})

      refute changeset.valid?
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.active == false
      assert user.email == "some@updated.email"
      assert user.username == "someupdated"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "get_user_by/1 returns the user with the matching username" do
      user = user_fixture()
      assert Accounts.get_user_by(username: user.username) == user
    end

    test "get_user_by/1 returns nil with no matching username" do
      assert is_nil(Accounts.get_user_by(username: "fail"))
    end
  end
end
