defmodule Concerts.Schemas.Artist do
  @moduledoc """
  Artist (/band/act/etc.) that plays Concerts at some Venue.
  """
  use Concerts.Schema

  alias Concerts.Schemas.ArtistsConcerts
  alias Concerts.Schemas.Concert

  schema "artists" do
    field :name, :string
    many_to_many :concerts, Concert, join_through: ArtistsConcerts

    timestamps()
  end

  @optional []
  @required [:name]

  @spec changeset(Artist.t(), map()) :: Ecto.Changeset.t()
  def changeset(%Artist{} = artist, params) do
    artist
    |> cast(params, @optional ++ @required)
    |> validate_required(@required)
  end

  @spec query :: Ecto.Query.t()
  def query, do: from(_ in Artist, as: :artist)
end
