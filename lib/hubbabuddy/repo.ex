defmodule Hubbabuddy.Repo do
  use Ecto.Repo,
    otp_app: :hubbabuddy,
    adapter: Ecto.Adapters.Postgres
end
