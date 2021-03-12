defmodule Homework.FuzzySearchHelper do
  defmacro levenshtein(str1, str2) do
    quote do
      fragment(
        "levenshtein(lower(?), lower(?))",
        (unquote(str1)),
        (unquote(str2))
      )
    end
  end

  defmacro levenshtein(str1, str2, fuzziness) do
    quote do
      levenshtein(unquote(str1), unquote(str2)) <= unquote(fuzziness)
    end
  end
end