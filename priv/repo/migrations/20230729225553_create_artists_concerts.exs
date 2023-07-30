defmodule Concerts.Repo.Migrations.CreateArtistsConcerts do
  use Ecto.Migration

  def change do
    create table(:artists_concerts) do
      add(:artist_id, references(:artists, type: :uuid), primary_key: true)
      add(:concert_id, references(:concerts, type: :uuid), primary_key: true)

      timestamps()
    end
  end
end
