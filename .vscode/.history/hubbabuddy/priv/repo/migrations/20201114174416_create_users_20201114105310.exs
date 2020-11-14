defmodule Hubbabuddy.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:github_token, :string)
      add(:slack_token, :string)
      timestamps()
    end

    create unique_index(:users, :email)

  end
end
