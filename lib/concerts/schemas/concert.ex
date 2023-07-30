defmodule Concerts.Schemas.Concert do
  @moduledoc """
  Concert played by an Artist(s) at a Venue.
  """
  use Concerts.Schema

  alias Concerts.Schemas.Artist
  alias Concerts.Schemas.ArtistsConcerts
  alias Concerts.Schemas.Venue

  schema "concerts" do
    belongs_to :venue, Venue, references: :id
    many_to_many :headliners, Artist, join_through: ArtistsConcerts
    field :start_time, :utc_datetime
    field :link, :string
    # openers, etc.
    # festivals?

    timestamps()
  end

  @optional []
  @required [:venue, :artists]

  @spec changeset(Concert.t(), map()) :: Ecto.Changeset.t()
  def changeset(%Concert{} = artist, params) do
    artist
    |> cast(params, @optional ++ @required)
    |> validate_required(@required)
    # validate other fields
  end

  @spec query :: Ecto.Query.t()
  def query, do: from(_ in Concert, as: :concert)
end
