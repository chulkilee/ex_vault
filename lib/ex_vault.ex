defmodule ExVault do
  @moduledoc """
  HashiCorp Vault API.

  - [HTTP API](https://www.vaultproject.io/api-docs)
  """

  alias ExVault.Config

  def build_client(%Config{addr: addr}, token \\ nil, adapter \\ nil) do
    Tesla.client(
      [
        {Tesla.Middleware.BaseUrl, addr},
        Tesla.Middleware.JSON,
        {Tesla.Middleware.Headers, build_headers(token)}
      ],
      adapter
    )
  end

  defp build_headers(nil), do: []
  defp build_headers(token), do: [{"x-vault-token", token}]
end
