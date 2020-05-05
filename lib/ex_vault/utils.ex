defmodule ExVault.Utils do
  @moduledoc false

  def uri_encode(val) when is_integer(val), do: to_string(val)
  def uri_encode(val) when is_atom(val), do: val |> to_string() |> uri_encode()
  def uri_encode(val), do: URI.encode(val, &URI.char_unreserved?/1)
end
