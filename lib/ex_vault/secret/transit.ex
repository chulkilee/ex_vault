defmodule ExVault.Secret.Transit do
  @moduledoc """
  Transit Secrets Engine.

  - [Transit Secrets Engine (API)](https://www.vaultproject.io/api/secret/transit/index.html)
  """

  import ExVault.Utils

  @doc """
  Generates a data key.

  See [Generate Data Key](https://www.vaultproject.io/api/secret/transit/index.html#generate-data-key) for details.
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

  See [Encrypt Data](https://www.vaultproject.io/api/secret/transit/index.html#encrypt-data) for details.
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

  See [Decrypt Data](https://www.vaultproject.io/api/secret/transit/index.html#decrypt-data) for details.
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
end