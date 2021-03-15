defmodule Paginator do
  @moduledoc """
  Provides pagination functionality for an Ecto query.
  """
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias Homework.Repo

  defstruct [:rows, :limit, :skip, :total_rows]

  @doc """
  Provides a pagination struct with list of result rows from provided query
  Paginate using same query by providing limit and skip parameters

    ## Examples
      iex> query = from row in Row
      iex> paginate(query, 100, 0)
      %Paginator{
        rows: [%Type{}],
        limit: 100,
        skip: 0,
        total_rows: 1000
      }

  """
  @spec paginate(Ecto.Query, integer, integer) :: Paginator
  def paginate(query, limit, skip) do
    %Paginator{
      rows: get_rows(query, limit, skip),
      limit: limit,
      skip: skip,
      total_rows: get_total_rows(query)
    }
  end

  defp get_rows(query, limit, skip) do
    query
    |> limit([_], ^limit)
    |> offset([_], ^skip)
    |> Repo.all
  end

  defp get_total_rows(query) do
    query
    |> exclude(:order_by)
    |> exclude(:preload)
    |> exclude(:select)
    |> Repo.aggregate(:count, :id)
  end
end