defmodule HubbabuddyWeb.AuthController do
  use HubbabuddyWeb, :controller
  plug Ueberauth
  alias Ueberauth.Strategy.Helpers, as: UeberauthHelpers
  alias HubbabuddyWeb.Router.Helpers, as: RouterHelpers
  alias Hubbabuddy.Users.User

  action_fallback(HubbabuddyWeb.ErrorController)

  def index(conn, _params) do
    render(conn, "index.html", user: get_session(conn, :current_user))
  end

  def request(conn, _params) do
    render(conn, "request.html",
      callback_url: UeberauthHelpers.callback_url(conn),
      provider: UeberauthHelpers.strategy_name(conn)
    )
  end

  def redirect_to_home(conn) do
    redirect(conn, to: RouterHelpers.page_path(conn, :index))
  end

  def delete(conn, _params) do
    Hubbabuddy.Users.clear_tokens(get_session(conn, :current_user))

    conn
    |> clear_session()
    |> put_flash(:info, "Your session has been cleared.")
    |> redirect_to_home()
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    attrs = %{
      "email" => auth.info.email,
      "#{UeberauthHelpers.strategy_name(conn)}_token" => auth.credentials.token
    }

    case get_session(conn, :current_user) do
      nil ->
        Hubbabuddy.Users.create_or_update_user(attrs)

      %User{id: user_id} ->
        Hubbabuddy.Users.update_user(Hubbabuddy.Users.get_user!(user_id), attrs)
    end
    |> case do
      {:ok, user} ->
        conn
        |> put_flash(
          :info,
          "Hubbabuddy is now authorized with #{UeberauthHelpers.strategy_name(conn)}!"
        )
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect_to_home()

      {:error, reason} ->
        IO.inspect(reason)

        conn
        |> put_flash(:error, "Something went wrong. 🙁")
        |> redirect_to_home()
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, params) do
    IO.inspect(params)

    conn
    |> put_flash(:error, "Failed to authenticate with #{UeberauthHelpers.strategy_name(conn)}.")
    |> redirect_to_home()
  end
end
