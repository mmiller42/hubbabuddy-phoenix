defmodule Hubbabuddy.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Hubbabuddy.Repo

  alias Hubbabuddy.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by email address.

  ## Examples

      iex> get_user_by_email("matt.miller@smartrent.com")
      %User{}

      iex> get_user_by_email("nonexistent@user.com")
      nil

  """
  def get_user_by_email(email) do
    Repo.one(from u in User, where: u.email == ^email)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    IO.puts("UPDATE USER")
    IO.inspect(user)
    IO.inspect(attrs)

    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> IO.inspect()
  end

  def create_or_update_user(%{} = attrs) do
    create_user(attrs) |> update_on_conflict(attrs)
  end

  defp update_on_conflict({:ok, user}, attrs) do
    IO.puts("update_on_conflict ALL")
    IO.inspect(user)
    IO.inspect(attrs)
    {:ok, user}
  end

  defp update_on_conflict(
         {:error,
          %Ecto.Changeset{
            errors: [email: {_message, [constraint: :unique, constraint_name: _constraint_name]}]
          }},
         %{"email" => email} = attrs
       ) do
    IO.puts("update_on_conflict ERROR CONFLICT")
    update_user(get_user_by_email(email), attrs)
  end

  defp update_on_conflict({:error, reason}, attrs) do
    IO.puts("update_on_conflict GENERAL ERROR")
    IO.inspect(reason)
    IO.inspect(attrs)
    {:error, reason}
  end

  @spec clear_tokens(Hubbabuddy.Users.User.t()) :: any
  def clear_tokens(%User{} = user) do
    try do
      update_user(user, %{"github_token" => nil, "slack_token" => nil})
    rescue
      _ -> nil
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
