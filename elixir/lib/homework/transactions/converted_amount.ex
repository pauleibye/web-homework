# The converted amount will store amounts as cents after conversion from decimal
# Assumes that query amount value will be in a decimal format
# Assumes that query return amount value will be in decimal format
# Assumes that amount stored in integer cents in db
defmodule Homework.Transactions.ConvertedAmount do
  use Ecto.Type

  def type, do: :integer

  def load(cents) when is_integer(cents) do
    {:ok, convert_to_decimal(cents)}
  end
  def load(_), do: :error

  def dump(cents) when is_integer(cents) do
    {:ok, cents}
  end
  def dump(_), do: :error

  def cast(decimal) when is_float(decimal) do
    {:ok, convert_to_cents(decimal)}
  end

  def cast(cents) when is_integer(cents) do
    {:ok, convert_to_cents(cents)}
  end
  def cast(_), do: :error

  defp convert_to_cents(decimal) do
    round(decimal * 100)
  end

  defp convert_to_decimal(cents) do
    cents / 100
  end
end