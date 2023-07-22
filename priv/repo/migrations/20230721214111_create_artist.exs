defmodule Concerts.Repo.Migrations.CreateArtist do
  use Ecto.Migration

  def change do
    create table(:artists, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :name, :string

      timestamps()
    end
  end
end
