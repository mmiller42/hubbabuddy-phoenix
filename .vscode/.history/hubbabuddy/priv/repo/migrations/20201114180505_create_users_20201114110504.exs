defmodule Hubbabuddy.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :github, :string
      add :slack_token, :string

      timestamps()
    end

  end
end
