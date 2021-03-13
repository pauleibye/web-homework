defmodule Homework.Repo.Migrations.AddFuzzysearchExtension do
  use Ecto.Migration

  def change do

  end

  def up do
    execute "CREATE extension if not exists fuzzystrmatch;"
  end

  def down do
    execute "DROP extension if exists fuzzystrmatch;"
  end
end
