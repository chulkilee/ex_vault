defmodule ExVault.Auth.Kubernetes do
  @moduledoc """
  Kubernetes Auth Method.

  - [Kubernetes Auth Method (API)](https://www.vaultproject.io/api/auth/kubernetes/index.html)
  """

  @doc """
  Fetch a token.

  See [Kubernetes Auth Method (API) - Login](https://www.vaultproject.io/api/auth/kubernetes/index.html#login) for details.
  """
  def login(client, %{role: _, jwt: _} = body, opts \\ []) do
    case Tesla.post(client, "v1/auth/kubernetes/login", body, opts) do
      {:ok, %{status: 200, body: %{"auth" => %{}}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end
end
