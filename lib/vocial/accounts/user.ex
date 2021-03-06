defmodule Vocial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :active, :boolean, default: true
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    field :oauth_provider, :string
    field :oauth_id, :string

    field :api_key, :string

    has_many :polls, Vocial.Votes.Poll
    has_many :images, Vocial.Votes.Image

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [
      :username,
      :email,
      :active,
      :password,
      :password_confirmation,
      :oauth_provider,
      :oauth_id,
      :api_key
    ])
    |> validate_confirmation(:password, message: "does not match password!")
    |> encrypt_password()
    |> validate_required([:username, :active, :encrypted_password])
    |> validate_length(:username, min: 3, max: 20)
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
  end

  defp encrypt_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))
    end
  end
end
