defmodule HomeworkWeb.Resolvers.MerchantsResolver do
  alias Homework.Merchants

  @doc """
  Get a list of merchants
  """
  def merchants(_root, args, _info) do
    {:ok, Merchants.list_merchants(args)}
  end

  @doc """
  Create a new merchant
  """
  @spec create_merchant(%{}, Merchant, %{}) :: {:ok, Merchant}
  def create_merchant(_root, args, _info) do
    case Merchants.create_merchant(args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not create merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a merchant for an id with args specified.
  """
  @spec update_merchant(%{}, Merchant, %{}) :: {:ok, Merchant} | {:error, String.t}
  def update_merchant(_root, %{id: id} = args, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.update_merchant(merchant, args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not update merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a merchant for an id
  """
  @spec delete_merchant(%{}, Merchant, %{}) :: {:ok, Merchant} | {:error, String.t}
  def delete_merchant(_root, %{id: id}, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.delete_merchant(merchant) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not update merchant: #{inspect(error)}"}
    end
  end
end
