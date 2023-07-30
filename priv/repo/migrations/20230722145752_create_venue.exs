defmodule Concerts.Repo.Migrations.CreateVenue do
  use Ecto.Migration

  def change do
    create table(:venues, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :name, :string, null: false
      add :address_1, :string
      add :address_2, :string
      add :city, :string
      add :state, :string
      add :zip_code, :integer
      add :website, :string

      timestamps()
    end
  end
end
