defmodule Concerts.Bot do
  use GenServer
  require Logger
  require Ecto.Query

  alias Concerts.Schemas.Artist

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
          updated_last_seen = handle_updates(updates, last_seen)
          Enum.each(updates, fn update ->
            GenServer.cast(self(), {:update, update})
          end)

          # update last_seen so we only get new updates on the next check
          %{state | last_seen: updated_last_seen}
      end

    schedule_next_check()
    {:noreply, state}
  end

  defp handle_updates(updates, last_seen) do
    updates
    |> Enum.map(fn update ->
      update["update_id"]
    end)
    |> Enum.max(fn -> last_seen end)
  end

  # can't get pattern matching on the update arg to work..
  @impl GenServer
  def handle_cast({:update, update}, %{bot_key: bot_key} = state) do
    case message_text(update) do
      "ping" ->
        send_message(bot_key, chat_id(update), "pong")
        {:noreply, state}
      "artists" ->
        artist_names =
          Ecto.Query.from(a in Artist, select: a.name, order_by: {:asc, :name})
          |> Concerts.Repo.all()
        send_message(bot_key, chat_id(update), Enum.join(artist_names, ", "))
        {:noreply, state}
      _ ->
        {:noreply, state}
    end
  end

  defp send_message(bot_key, chat_id, text) do
      Telegram.Api.request(bot_key, "sendMessage", chat_id: chat_id, text: text)
  end

  defp message_text(update) do
    update
      |> Map.get("message")
      |> Map.get("text")
      |> String.downcase()
  end

  defp chat_id(update) do
    update
      |> Map.get("message")
      |> Map.get("chat")
      |> Map.get("id")
  end

  def handle_cast({:update, _update}, state), do: {:noreply, state}

  defp broadcast(update) do
    Phoenix.PubSub.broadcast!(Concerts.PubSub, "bot_update", {:update, update})
  end

  defp schedule_next_check do
    Process.send_after(self(), :check, 2000) # check every 2 seconds
  end
end
