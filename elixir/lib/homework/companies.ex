defmodule Homework.Companies do
  @moduledoc """
  The Companies context.
  """

  import Homework.FuzzySearchHelper
  #  alias Homework.FuzzySearchHelper, as: FSH

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Companies.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies([])
      [%Company{}, ...]

  """
  def list_companies(_args) do
    Repo.all(Company)
    |> Company.fill_virtual_fields()
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id) |> Company.fill_virtual_fields()

  @doc """
  Gets all merchants with exact matching field name
  """
  def get_companies_where_name(name) do
    query = from c in Company,
      where: c.name == ^name
    Repo.all(query)
    |> Company.fill_virtual_fields()
  end

  @doc """
  Gets all companies that have a provided or higher levenshtein fuzziness

  ## Examples

      iex> get_companies_fuzzy("paul", 5)
      [%Company{...name: "paulco"...}]

  """
  def get_companies_fuzzy(to_query, fuzziness) do
    # TODO call levenshtein function once and store as a row, then use to order (rather than 4 calls), then map to company
    query = from c in Company,
                 where:
                   levenshtein(c.name, ^to_query, ^fuzziness),
                 order_by:
                    levenshtein(c.name, ^to_query)

    Repo.all(query)
    |> Company.fill_virtual_fields()

  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end
end
