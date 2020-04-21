defmodule Vocial.Votes.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :title, :string

    has_many :options, Vocial.Votes.Option
    has_many :vote_records, Vocial.Votes.VoteRecord
    has_many :messages, Vocial.Votes.Message
    has_one :image, Vocial.Votes.Image

    belongs_to :user, Vocial.Accounts.User

    timestamps()
  end

  def changeset(%__MODULE__{} = poll, attrs \\ %{}) do
    poll
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
