defmodule Concerts.Schemas.ArtistsConcerts do
  @moduledoc """
  Joins Artists and Concerts (many-to-many).
  """
  use Concerts.Schema

  alias Concerts.Schemas.Artist
  alias Concerts.Schemas.Concert

  schema "artists_concerts" do
    belongs_to :artist, Artist
    belongs_to :concert, Concert

    timestamps()
  end

  @optional []
  @required [:artist, :concert]

  @spec changeset(ArtistsConcerts.t(), map()) :: Ecto.Changeset.t()
  def changeset(%ArtistsConcerts{} = artists_concerts, params) do
    artists_concerts
    |> cast(params, @optional ++ @required)
    |> validate_required(@required)
  end
end
