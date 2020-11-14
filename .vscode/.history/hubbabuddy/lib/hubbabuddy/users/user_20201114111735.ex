defmodule Hubbabuddy.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :github_token, :string
    field :slack_token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :github_token, :slack_token])
    |> validate_required([:email])
    |> unique_constraint([:email])
  end
end
