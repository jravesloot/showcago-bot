defmodule Concerts.Repo.Migrations.CreateConcert do
  use Ecto.Migration

  def change do
    create table(:concerts, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :venue_id, references(:venues, type: :uuid)
      add :headliners, references(:artists, type: :uuid)
      add :start_time, :utc_datetime
      add :link, :string

      timestamps()
    end
  end
end
