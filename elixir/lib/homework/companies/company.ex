# users should belong to a company and we should require transactions to pass in a company_id
# companies have a name, credit_line, and available_credit is
#   the credit_line minus the total amount of transactions for the company
defmodule Homework.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Homework.Repo
  alias Homework.Transactions.Transaction

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "companies" do
    field(:name, :string)
    field(:credit_line, :float)
    field(:available_credit, :float, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :credit_line])
    |> validate_required([:name, :credit_line])
#    |> foreign_key_constraint(:companies, name: :users_company_id_fkey, message: "user exists in company")
  end

  def fill_virtual_fields(list) when is_list(list) do
    Enum.map(list, fn c -> fill_virtual_fields(c) end)
  end

  def fill_virtual_fields(company) do
    # available_credit` is the company `credit_line` minus the total amount of `transactions`
    query = from t in Transaction,
      where: t.company_id == ^company.id
    %{company | available_credit: company.credit_line - (Repo.aggregate(query, :sum, :amount) * 100)}
  end
end
