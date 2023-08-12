defmodule Concerts.Repo.Migrations.CreateVenue do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table(:venues, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :name, :citext, null: false
      add :address_1, :string
      add :address_2, :string
      add :city, :string
      add :state, :string
      add :zip_code, :integer
      add :website, :string

      timestamps()
    end

    create unique_index(:venues, [:name, :city])
  end
end
