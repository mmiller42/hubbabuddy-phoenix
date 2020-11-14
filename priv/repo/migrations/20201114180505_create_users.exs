defmodule Hubbabuddy.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table(:users) do
      add :email, :citext
      add :github_token, :string
      add :slack_token, :string

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
