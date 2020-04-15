defmodule Vocial.Votes.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    field :title, :string
    field :votes, :integer, default: 0

    belongs_to :poll, Vocial.Votes.Poll

    timestamps()
  end

  def changeset(%__MODULE__{} = option, attrs \\ %{}) do
    option
    |> cast(attrs, [:title, :votes, :poll_id])
    |> validate_required([:title, :votes, :poll_id])
  end
end
