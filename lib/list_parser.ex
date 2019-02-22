defmodule ListParser do
  @moduledoc false

  defmacro __using__(_) do
    file_prefixes = ["41", "42", "51", "52"]

    maps_list =
      Enum.map(file_prefixes, fn file_prefix ->
        word_length_list =
          file_prefix
          |> String.to_integer()
          |> Integer.digits()
          |> hd()

        ("lists/" <> file_prefix <> ".txt")
        |> File.read!()
        |> String.split("\r\n")
        |> Enum.reduce(%{}, fn <<dice::binary-size(word_length_list), " ", word::binary>>, acc ->
          Map.put(acc, dice, word)
        end)
      end)

    [file_prefixes, maps_list]
    |> List.zip()
    |> Enum.map(fn {file_prefix, map} ->
      function_name = String.to_atom("get_#{file_prefix}")

      quote do
        def unquote(function_name)(), do: unquote(Macro.escape(map))
      end
    end)
  end
end
