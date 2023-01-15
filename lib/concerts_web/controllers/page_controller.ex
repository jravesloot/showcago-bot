defmodule ConcertsWeb.PageController do
  use ConcertsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
