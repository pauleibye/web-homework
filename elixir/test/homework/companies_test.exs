defmodule Homework.CompaniesTest do
  use Homework.DataCase

  alias Homework.Companies

  describe "companies" do
    alias Homework.Companies.Company

    @valid_attrs %{name: "some company_name", credit_line: 100.0, available_credit: 100.0}
    @update_attrs %{
      name: "some updated company_name",
      credit_line: 51,
      available_credit: 49
    }
    @invalid_attrs %{name: nil, credit_line: nil, available_credit: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_companies/1 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies([]) == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.name == "some company_name"
      assert company.credit_line == 100
      assert company.available_credit == 100
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.name == "some updated company_name"
      assert company.credit_line == 51
      assert company.available_credit == 49
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end

    test "get_companies_fuzzy/return companies within a levenshtein distance based on first and last name" do
      company = company_fixture()
      assert [company] == Companies.get_companies_fuzzy("some company_name", 5)
    end
  end
end
