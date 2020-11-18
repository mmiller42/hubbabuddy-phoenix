defmodule HubbabuddyWeb.AuthView do
  use HubbabuddyWeb, :view
  alias HubbabuddyWeb.Router.Helpers, as: RouterHelpers

  def authorize_link(conn, user, provider) do
    text = "Authorize #{provider}"
    href = RouterHelpers.auth_path(conn, :request, provider)
    token_name = String.to_existing_atom("#{provider}_token")

    cond do
      user == nil || Map.get(user, token_name) == nil -> link(text, to: href)
      true -> "You are already authorized with #{provider}"
    end
  end
end
