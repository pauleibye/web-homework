defmodule Homework.Users do
  @moduledoc """
  The Users context.
  """

  import Homework.FuzzySearchHelper
  import Ecto.Query, warn: false
  import Paginator
  alias Homework.Repo
  alias Homework.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users([])
      [%User{}, ...]

  """
  def list_users(_args) do
    Repo.all(User)
  end

  def list_users_paginated(_args, limit, skip) do
    Paginator.paginate((from u in User), limit, skip)
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

  # TODO test (one and multiple) and doc
  def get_users_where_name(first_name, last_name) do
    query = from u in User,
      where: u.first_name == ^first_name,
      where: u.last_name == ^last_name
    Repo.all(query)
  end

  @doc """
  Gets all users that have a provided or higher levenshtein fuzziness.
  Users chosen by first_name and last_name fuzziness

  ## Examples

      iex> get_users_fuzzy("paul", 5)
      [%User{...first_name: "paul", last_name: "andersen"...}]

  """
  def get_users_fuzzy(to_query, fuzziness) do
    # TODO call levenshtein function once and store as a row, then use to order (rather than 4 calls), then map to user
    query = from u in User,
                  where:
                    levenshtein(u.first_name, ^to_query, ^fuzziness) or
                    levenshtein(u.last_name, ^to_query, ^fuzziness),
                  order_by:
                    fragment(
                      "least(?, ?)",
                      levenshtein(u.first_name, ^to_query),
                      levenshtein(u.last_name, ^to_query)
                    )

    Repo.all(query)
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
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
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
