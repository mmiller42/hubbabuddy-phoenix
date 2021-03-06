defmodule Hubbabuddy.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :github, :string
    field :slack_token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :github, :slack_token])
    |> validate_required([:email, :github, :slack_token])
  end
end
