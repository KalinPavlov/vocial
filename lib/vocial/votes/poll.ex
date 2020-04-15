defmodule Vocial.Votes.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :title, :string

    has_many :options, Vocial.Votes.Option
    belongs_to :user, Vocial.Accounts.User

    timestamps()
  end

  def changeset(%__MODULE__{} = poll, attrs \\ %{}) do
    poll
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
