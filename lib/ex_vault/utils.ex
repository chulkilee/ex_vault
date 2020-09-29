defmodule ExVault.Utils do
  @moduledoc false

  def uri_encode(val) when is_integer(val), do: to_string(val)
  def uri_encode(val) when is_atom(val), do: val |> to_string() |> uri_encode()
  def uri_encode(val), do: URI.encode(val, &URI.char_unreserved?/1)

  def to_uri_path(secret_path) when is_list(secret_path),
    do: secret_path |> Enum.map(&uri_encode/1) |> Enum.join("/")

  def to_uri_path(secret_path), do: uri_encode(secret_path)

  def handle_response({:ok, %{status: status, body: %{"data" => _}} = resp})
      when status in [200, 204],
      do: {:ok, resp}

  def handle_response({:ok, %{status: status, body: %{"auth" => _}} = resp})
      when status in [200, 204],
      do: {:ok, resp}

  def handle_response({_, other}), do: {:error, other}
end
