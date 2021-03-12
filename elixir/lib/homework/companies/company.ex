# users should belong to a company and we should require transactions to pass in a company_id
# companies have a name, credit_line, and available_credit is
#   the credit_line minus the total amount of transactions for the company
defmodule Homework.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "companies" do
    field(:name, :string)
    field(:credit_line, :float)
    # TODO not so sure about having a continuously generated field present in a static record
    # TODO  might want to move this out to it's own table
    field(:available_credit, :float)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :credit_line, :available_credit])
    |> validate_required([:name, :credit_line, :available_credit])
  end
end
