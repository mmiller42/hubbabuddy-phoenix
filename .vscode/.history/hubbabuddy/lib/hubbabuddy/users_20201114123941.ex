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
    Repo.one(from u in User, where: u.email == ^email, select: u)
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
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Creates the user if it does not exist or updates it if the email address is
  already associated with a user.

  ## Examples

      iex> create_or_update_user(%{"email" => "matt.miller@smartrent.com", "github_token" => "123"})
      {:ok, %User{}} # Updated existing user

      iex> create_or_update_user(%{"email" => "new@user.com", "github_token" => "456"})
      {:ok, %User{}} # Created new user

      iex> create_or_update_user(%{"email" => "", "github_token" => "456"})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_or_update_user(%{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          any
  def create_or_update_user(%{"email" => email} = attrs) do
    case create_user(attrs) do
      {:ok, user} ->
        {:ok, user}

      {:error,
       %Ecto.Changeset{
         errors: [email: {_message, [constraint: :unique, constraint_name: _constraint_name]}]
       }} ->
        update_user(get_user_by_email(email), attrs)
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
