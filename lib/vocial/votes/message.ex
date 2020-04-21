defmodule Vocial.Votes.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :author, :string

    belongs_to :poll, Vocial.Votes.Poll

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = message, attrs) do
    message
    |> cast(attrs, [:message, :author, :poll_id])
    |> validate_required([:message, :author])
  end
end
