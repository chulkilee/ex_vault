defmodule ExVault.Auth.Token do
  @moduledoc """
  Token Auth Method.

  - [Token Auth Method (API) ](https://www.vaultproject.io/api/auth/token/index.html)
  """

  @doc """
  Looks up a self token.

  See [Lookup a Token (Self)](https://www.vaultproject.io/api/auth/token/index.html#lookup-a-token-self) for details.
  """
  def lookup_self(client, opts \\ []) do
    case Tesla.get(client, "v1/auth/token/lookup-self", opts) do
      {:ok, %{status: 200, body: %{"data" => _}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Renews a self token.

  See [Renew a Token (Self)](https://www.vaultproject.io/api/auth/token/index.html#renew-a-token-self) for details.
  """
  def renew_self(client, body, opts \\ []) do
    case Tesla.post(client, "v1/auth/token/renew-self", body, opts) do
      {:ok, %{status: 200, body: %{"auth" => _}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end
end
