# TODO doc for paginator
defmodule Paginator do
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias Homework.Repo

  defstruct [:rows, :limit, :skip, :total_rows]

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