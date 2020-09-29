defmodule ExVault.Auth.Token do
  @moduledoc """
  Token Auth Method.

  - [Token Auth Method (API)](https://www.vaultproject.io/api-docs/auth/token)
  """

  import ExVault.Utils

  @doc """
  Looks up a self token.

  See [Lookup a Token (Self)](https://www.vaultproject.io/api-docs/auth/token#lookup-a-token-self) for details.
  """
  def lookup_self(client, opts \\ []) do
    client
    |> Tesla.get("v1/auth/token/lookup-self", opts)
    |> handle_response()
  end

  @doc """
  Renews a self token.

  See [Renew a Token (Self)](https://www.vaultproject.io/api-docs/auth/token#renew-a-token-self) for details.
  """
  def renew_self(client, body, opts \\ []) do
    client
    |> Tesla.post("v1/auth/token/renew-self", body, opts)
    |> handle_response()
  end
end
