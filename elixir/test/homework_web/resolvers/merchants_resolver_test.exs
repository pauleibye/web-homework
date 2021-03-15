defmodule Homework.MerchantsResolverTest do
  @moduledoc """
  Tests merchant resolver methods, as called from graphql
  """
  use Homework.DataCase
  alias Homework.Merchants.Merchant
  alias HomeworkWeb.Resolvers.MerchantsResolver

  # TODO question: should these integration tests be up a level (json http request tests)?
  describe "merchants_resolver" do
    # TODO fix warnings coming from this test, related to syntax
    test "get all merchants" do
      {:ok, %Merchant{} = merchant_before} = MerchantsResolver.create_merchant(nil, %{description: "some description", name: "some name"}, %{})
      assert {:ok, [%Merchant{}] = merchants} = MerchantsResolver.merchants(nil, nil, %{})
      assert [merchant_before] = merchants
    end


    test "creates a new merchant with valid attributes through resolver" do
      assert {:ok, %Merchant{} = merchant} = MerchantsResolver.create_merchant(nil, %{description: "some description", name: "some name"}, %{})
      assert %{description: "some description", name: "some name"} = merchant
      assert merchant.inserted_at != nil
      assert merchant.updated_at != nil
      assert merchant.id != nil
    end

    test "updates a merchant with valid attributes through resolver" do
      {:ok, %Merchant{} = merchant_before} = MerchantsResolver.create_merchant(nil, %{description: "some description", name: "some name"}, %{})
      assert {:ok, %Merchant{} = merchant_after} = MerchantsResolver.update_merchant(nil, %{id: merchant_before.id, description: "some updated description"}, %{})
      assert %{description: "some updated description", name: "some name"} = merchant_after
    end

    test "deletes a merchant with valid attributes through resolver" do
      {:ok, %Merchant{} = merchant_before} = MerchantsResolver.create_merchant(nil, %{description: "some description", name: "some name"}, %{})
      assert {:ok, %Merchant{} = merchant} = MerchantsResolver.delete_merchant(nil, merchant_before, %{})
      assert merchant_before = merchant
    end
  end
end