defmodule Homework.TransactionsTest do
  use Homework.DataCase

  alias Homework.Merchants
  alias Homework.Transactions
  alias Homework.Users
  alias Homework.Companies

  describe "transactions" do
    alias Homework.Transactions.Transaction

    setup do
      {:ok, company1} =
        Companies.create_company(%{name: "some company_name", credit_line: 100.0, available_credit: 100.0})

      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})

      {:ok, merchant2} =
        Merchants.create_merchant(%{
          description: "some updated description",
          name: "some updated name"
        })

      {:ok, user1} =
        Users.create_user(%{
          dob: "some dob",
          first_name: "some first_name",
          last_name: "some last_name",
          company_id: company1.id
        })

      {:ok, user2} =
        Users.create_user(%{
          dob: "some updated dob",
          first_name: "some updated first_name",
          last_name: "some updated last_name",
          company_id: company1.id
        })

      valid_attrs = %{
        amount: 0.42,
        credit: true,
        debit: false,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id,
        company_id: user1.company_id
      }

      update_attrs = %{
        amount: 0.43,
        credit: true,
        debit: false,
        description: "some updated description",
        merchant_id: merchant2.id,
        user_id: user2.id,
        company_id: user2.company_id
      }

      invalid_attrs = %{
        amount: nil,
        credit: nil,
        debit: nil,
        description: nil,
        merchant_id: nil,
        user_id: nil,
        company_id: nil
      }

      {:ok,
       %{
         valid_attrs: valid_attrs,
         update_attrs: update_attrs,
         invalid_attrs: invalid_attrs,
         merchant1: merchant1,
         merchant2: merchant2,
         user1: user1,
         user2: user2
       }}
    end

    def transaction_fixture(valid_attrs, attrs \\ %{}) do
      {:ok, transaction_created} =
        attrs
        |> Enum.into(valid_attrs)
        |> Transactions.create_transaction()

      Transactions.get_transaction!(transaction_created.id)
    end

    test "list_transactions/1 returns all transactions", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert Transactions.list_transactions([]) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{
      valid_attrs: valid_attrs,
      merchant1: merchant1,
      user1: user1
    } do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.amount == 42
      assert transaction.credit == true
      assert transaction.debit == false
      assert transaction.description == "some description"
      assert transaction.merchant_id == merchant1.id
      assert transaction.user_id == user1.id
    end

    test "create_transaction/1 with invalid data returns error changeset", %{
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction", %{
      valid_attrs: valid_attrs,
      update_attrs: update_attrs,
      merchant2: merchant2,
      user2: user2
    } do
      transaction = transaction_fixture(valid_attrs)

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.amount == 43
      assert transaction.credit == true
      assert transaction.debit == false
      assert transaction.description == "some updated description"
      assert transaction.merchant_id == merchant2.id
      assert transaction.user_id == user2.id
    end

    test "update_transaction/2 with invalid data returns error changeset", %{
      valid_attrs: valid_attrs,
      invalid_attrs: invalid_attrs
    } do
      transaction = transaction_fixture(valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end

    test "get_transactions_time_range/? returns transactions within parameter time range", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      search_start = NaiveDateTime.utc_now() |> NaiveDateTime.add(-3600)
      search_end = NaiveDateTime.utc_now() |> NaiveDateTime.add(3600)
      assert [transaction] == Transactions.get_transactions_time_range(search_start, search_end)
    end

    test "get_transactions_amount_range/? returns transactions within parameter amount range", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      assert [transaction] == Transactions.get_transactions_amount_range(0.40, 0.43)
      assert [] == Transactions.get_transactions_amount_range(0.00, 0.01)
    end
  end
end
