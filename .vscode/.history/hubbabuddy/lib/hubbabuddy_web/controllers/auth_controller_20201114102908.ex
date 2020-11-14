defmodule HubbabuddyWeb.AuthController do
  use HubbabuddyWeb, :controller
  plug Ueberauth
  alias Ueberauth.Strategy.Helpers, as: UeberauthHelpers
  alias HubbabuddyWeb.Router.Helpers, as: RouterHelpers
  alias HubbabuddyWeb.Endpoint

  def request(conn, _params) do
    render(conn, "request.html", callback_url: UeberauthHelpers.callback_url(conn))
  end

  def redirect_to_home(conn) do
    redirect(to: RouterHelpers.page_path(conn, :index))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> clear_session()
    |> redirect_to_home()
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect_to_home()

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect_to_home()
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, params) do
    IO.inspect(params)

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect_to_home()
  end
end
