defmodule ExVault.Secret.Transit do
  @moduledoc """
  Transit Secrets Engine.

  - [Transit Secrets Engine (API)](https://www.vaultproject.io/api-docs/secret/transit)
  """

  import ExVault.Utils

  @doc """
  Reads a key.

  See [Read Key](https://www.vaultproject.io/api-docs/secret/transit#read-key) for details.
  """
  def read_key(client, path, name, opts \\ []) do
    case Tesla.get(client, "v1/" <> uri_encode(path) <> "/keys/" <> uri_encode(name), opts) do
      {:ok, %{status: 200, body: %{"data" => %{}}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Signs data.

  See [Sign data](https://www.vaultproject.io/api-docs/secret/transit#sign-data) for details.
  """
  def sign_data(client, path, name, payload, opts \\ []) do
    case Tesla.post(
           client,
           "v1/" <> uri_encode(path) <> "/sign/" <> uri_encode(name),
           payload,
           opts
         ) do
      {:ok, %{status: 200, body: %{"data" => %{}}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Generates a data key.

  See [Generate Data Key](https://www.vaultproject.io/api-docs/secret/transit#generate-data-key) for details.
  """
  def generate_data_key(client, path, type, name, body, opts \\ []) do
    case Tesla.post(
           client,
           "v1/" <>
             uri_encode(path) <> "/datakey/" <> uri_encode(type) <> "/" <> uri_encode(name),
           body,
           opts
         ) do
      {:ok, %{status: 200, body: %{"data" => %{}}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Encrypts data.

  See [Encrypt Data](https://www.vaultproject.io/api-docs/secret/transit#encrypt-data) for details.
  """
  def encrypt_data(client, path, name, body, opts \\ []) do
    case Tesla.post(
           client,
           "v1/" <> uri_encode(path) <> "/encrypt/" <> uri_encode(name),
           body,
           opts
         ) do
      {:ok, %{status: 200, body: %{"data" => %{}}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Decrypts data.

  See [Decrypt Data](https://www.vaultproject.io/api-docs/secret/transit#decrypt-data) for details.
  """
  def decrypt_data(client, path, name, body, opts \\ []) do
    case Tesla.post(
           client,
           "v1/" <> uri_encode(path) <> "/decrypt/" <> uri_encode(name),
           body,
           opts
         ) do
      {:ok, %{status: 200, body: %{"data" => %{}}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Rewrap data.

  See [Rewrap Data](https://www.vaultproject.io/api-docs/secret/transit#rewrap-data) for details.
  """
  def rewrap_data(client, path, name, body, opts \\ []) do
    case Tesla.post(
           client,
           "v1/" <> uri_encode(path) <> "/rewrap/" <> uri_encode(name),
           body,
           opts
         ) do
      {:ok, %{status: 200, body: %{"data" => %{}}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end
end
