defmodule HubbabuddyWeb.PageView do
  use HubbabuddyWeb, :view
  alias HubbabuddyWeb.Router.Helpers, as: RouterHelpers

  def pull_requests(user) do
    response =
      Tentacat.Client.new(%{access_token: user.github_token})
      |> Tentacat.Pulls.filter("mmiller42", "starter", %{status: "open"})

    case response do
      {200, pull_requests, _response} -> pull_requests
      {_status, reason, response} -> IO.inspect(reason) && IO.inspect(response) && nil
    end
  end
end
