defmodule Concerts.Schema do
  @moduledoc """
  Shared schema attributes.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query
      alias __MODULE__

      @type t :: %__MODULE__{}

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
