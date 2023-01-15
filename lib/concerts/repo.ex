defmodule Concerts.Repo do
  use Ecto.Repo,
    otp_app: :concerts,
    adapter: Ecto.Adapters.Postgres
end
