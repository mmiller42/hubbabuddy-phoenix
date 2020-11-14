defmodule HubbabuddyWeb.PageController do
  use HubbabuddyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
