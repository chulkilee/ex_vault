defmodule ExVault.Auth.Kubernetes do
  @moduledoc """
  Kubernetes Auth Method.

  - [Kubernetes Auth Method (API)](https://www.vaultproject.io/api-docs/auth/kubernetes)
  """

  import ExVault.Utils

  @doc """
  Fetch a token.

  See [Kubernetes Auth Method (API) - Login](https://www.vaultproject.io/api-docs/auth/kubernetes#login) for details.
  """
  def login(client, %{role: _, jwt: _} = body, opts \\ []) do
    client
    |> Tesla.post("v1/auth/kubernetes/login", body, opts)
    |> handle_response()
  end
end
