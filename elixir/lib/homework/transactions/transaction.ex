defmodule Homework.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homework.Merchants.Merchant
  alias Homework.Users.User
  alias Homework.Companies.Company
  alias Homework.Transactions.ConvertedAmount


  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transactions" do
    field(:amount, ConvertedAmount)
    field(:credit, :boolean, default: false)
    field(:debit, :boolean, default: false) # TODO should one of these be default true?
    field(:description, :string)

    belongs_to(:merchant, Merchant, type: :binary_id, foreign_key: :merchant_id)
    belongs_to(:user, User, type: :binary_id, foreign_key: :user_id)
    belongs_to(:company, Company, type: :binary_id, foreign_key: :company_id)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :amount, :debit, :credit, :description, :merchant_id, :company_id])
    |> validate_required([:user_id, :amount, :description, :merchant_id, :company_id])
  end

  def convert_amount_to_cents(transaction) when is_float(transaction.amount) do

  end
end
