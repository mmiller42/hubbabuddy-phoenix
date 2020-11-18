defmodule HubbabuddyWeb.PageController do
  use HubbabuddyWeb, :controller
  alias HubbabuddyWeb.Router.Helpers, as: RouterHelpers

  def index(conn, _params) do
    render(conn, "index.html", current_user: get_session(conn, :current_user))
  end

  def send_slack(conn, _params) do
    HTTPoison.post(
      "https://hooks.slack.com/services/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",
      '{"text": "sup"}',
      [{"Content-Type", "application/json"}]
    )

    conn
    |> put_flash(:info, "whatever")
    |> redirect(to: RouterHelpers.page_path(conn, :index))
  end
end
