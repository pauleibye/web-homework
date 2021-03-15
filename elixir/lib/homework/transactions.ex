defmodule Homework.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  import Paginator
  alias Homework.Repo

  alias Homework.Transactions.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions([])
      [%Transaction{}, ...]

  """
  @spec list_transactions(any) :: [Transaction]
  def list_transactions(_args) do
    Repo.all(Transaction)
  end

  @doc """
  Gets paginated list of transactions
  """
  @spec list_transactions_paginated(Ecto.Query, integer, integer) :: [Transaction]
  def list_transactions_paginated(_args, limit, skip) do
    Paginator.paginate((from t in Transaction), limit, skip)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_transaction!(String.t) :: Transaction | Ecto.NoResultsError
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  # TODO method to get all transactions for a merchant, user, etc

  # TODO parameter to choose to query for inserted_at or updated_at (macro?)
  @doc """
  Gets all transactions where inserted_at field is between a passed start and end date time
  Start and end date times are in Naive DateTime format
  """
  @spec get_transactions_time_range(NaiveDateTime, NaiveDateTime) :: [Transaction]
  def get_transactions_time_range(start_date_time, end_date_time) do
    query = from t in Transaction,
      where:  t.inserted_at >= ^start_date_time,
      where:  t.inserted_at < ^end_date_time

    Repo.all(query)
  end

  @doc """
    Get all transactions with amount between range (decimal notation dollars.cents)

    ## Examples

      iex> get_transactions_amount_range(0.41, 0.45)
        [%Transaction{...amount: 0.43...}]
  """
  @spec get_transactions_amount_range(integer, integer) :: [Transaction]
  # When I added the ecto type for converted amounts I expected to need to convert min and max in this query.
  # I was surprised to find out that ecto will convert the min and max based on my defined dump methods, so I don't need
  #   to have multiple conversion methods - super cool!
  def get_transactions_amount_range(min, max) do
    query = from t in Transaction,
      where: t.amount >= ^min,
      where: t.amount < ^max
    Repo.all(query)
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_transaction(Transaction) :: Transaction
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_transaction(Transaction, %{}) :: {:ok, Transaction} | {:error, Ecto.Changeset}
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_transaction(Transaction) :: {:ok, Transaction} | {:error, Ecto.Changeset}
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  @spec change_transaction(Transaction, %{}) :: Ecto.Changeset
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
