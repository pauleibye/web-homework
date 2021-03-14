defmodule Homework.PaginatorTest do
  use Homework.DataCase
  alias Homework.Merchants
  alias Homework.Merchants.Merchant
  import Ecto.Query, warn: false

  # TODO tests for paginator
  describe "paginator" do

    setup do
      Enum.each(1..9, fn(_) ->
        Merchants.create_merchant(%{description: "some description", name: "some name"})
      end)
      Merchants.create_merchant(%{description: "the one", name: "the only"})
      {:ok, %{merchants: Merchants.get_merchants_where_name!("the only")}}
    end

    test "paginate happy path", %{merchants: merchants} do
      paginator = Paginator.paginate((from m in Merchant), 1, 9)
      assert paginator.rows == merchants
      assert paginator.limit == 1
      assert paginator.skip == 9
      assert paginator.total_rows == 10
    end
  end
end