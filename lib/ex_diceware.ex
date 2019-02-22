defmodule ExDiceware do
  @moduledoc false

  use ListParser

  @spec create_passphrase(pos_integer) :: String.t()
  def create_passphrase(number_of_words) do
    1..number_of_words
    |> Enum.map(fn _x ->
      word_length_list = :rand.uniform(2) + 3

      word_length_list
      |> dice_roll()
      |> get_word_from_wordlists(word_length_list)
    end)
    |> Enum.join()
  end

  defp dice_roll(word_length_list) do
    1..word_length_list
    |> Enum.map(fn _x -> :rand.uniform(6) end)
    |> Enum.join()
  end

  defp get_word_from_wordlists(dice, word_length_list) do
    secondary_list_number = :rand.uniform(2)

    function_name = String.to_atom("get_#{word_length_list}#{secondary_list_number}")

    __MODULE__
    |> apply(function_name, [])
    |> Map.get(dice)
  end
end
