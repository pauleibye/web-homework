defmodule Homework.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:credit_line, :float)
      add(:available_credit, :float)

      timestamps()
    end
  end
end
