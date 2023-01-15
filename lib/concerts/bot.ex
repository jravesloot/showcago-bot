defmodule Concerts.Bot do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  @impl GenServer
  def init(opts) do
    {key, _opts} = Keyword.pop!(opts, :bot_key)

    case Telegram.Api.request(key, "getMe") do
      {:ok, me} ->
        Logger.info("Bot successfully self-identified: #{me["username"]}")

        state = %{
          bot_key: key,
          me: me,
          last_seen: -2
        }
        schedule_next_check()

        {:ok, state}

      error ->
        Logger.error("bot failed to self-identify: #{inspect(error)}")
        :error
    end
  end

  @impl GenServer
  def handle_info(:check, %{bot_key: key, last_seen: last_seen} = state) do
    state =
      key
      |> Telegram.Api.request("getUpdates", offset: last_seen + 1, timeout: 30)
      |> case do
        # Empty; typically a timeout or no new messages?
        {:ok, []} ->
          state

        {:ok, updates} ->
          last_seen = handle_updates(updates, last_seen)

          # update last_seen so we only get new updates on the next check
          %{state | last_seen: last_seen}
      end

    schedule_next_check()
    {:noreply, state}
  end

  defp handle_updates(updates, last_seen) do
    updates
    |> Enum.map(fn update ->
      Logger.info("Updated received: #{inspect(update)}")
      broadcast(update)

      update["update_id"]
    end)
    |> Enum.max(fn -> last_seen end)
  end

  defp broadcast(update) do
    Phoenix.PubSub.broadcast!(Concerts.PubSub, "bot_update", {:update, update})
  end

  defp schedule_next_check do
    Process.send_after(self(), :check, 2000) # check every 2 seconds
  end
end
