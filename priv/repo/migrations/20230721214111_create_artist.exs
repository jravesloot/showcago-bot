defmodule Concerts.Repo.Migrations.CreateArtist do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table(:artists, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :name, :citext, null: false

      timestamps()
    end

    create unique_index(:artists, [:name])
  end
end
