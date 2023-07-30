defmodule Concerts.Schemas.Venue do
  @moduledoc """
  Venue where an Artist(s) plays a Concert.
  """
  use Concerts.Schema

  alias Concerts.Schemas.Concert

  schema "venues" do
    field :name, :string
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :zip_code, :integer
    field :website, :string
    has_many :concerts, Concert

    timestamps()
  end

  @optional [:address_1, :address_2, :street, :city, :state, :zip_code, :website]
  @required [:name]

  @spec changeset(Venue.t(), map()) :: Ecto.Changeset.t()
  def changeset(%Venue{} = artist, params) do
    artist
    |> cast(params, @optional ++ @required)
    |> validate_required(@required)
    # validate other fields (lib for addresses?)
  end

  @spec query :: Ecto.Query.t()
  def query, do: from(_ in Venue, as: :venue)
end
