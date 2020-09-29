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
    url_path = "v1/" <> uri_encode(path) <> "/keys/" <> uri_encode(name)

    client
    |> Tesla.get(url_path, opts)
    |> handle_response()
  end

  @doc """
  Rotate a key.

  See [Rotate Key](https://www.vaultproject.io/api-docs/secret/transit#rotate-key) for details.
  """
  def rotate_key(client, path, name, opts \\ []) do
    url_path = "v1/" <> uri_encode(path) <> "/keys/" <> uri_encode(name) <> "/rotate"

    client
    |> Tesla.post(url_path, "", opts)
    |> handle_response()
  end

  @doc """
  Signs data.

  See [Sign data](https://www.vaultproject.io/api-docs/secret/transit#sign-data) for details.
  """
  def sign_data(client, path, name, payload, opts \\ []) do
    url_path = "v1/" <> uri_encode(path) <> "/sign/" <> uri_encode(name)

    client
    |> Tesla.post(url_path, payload, opts)
    |> handle_response()
  end

  @doc """
  Generates a data key.

  See [Generate Data Key](https://www.vaultproject.io/api-docs/secret/transit#generate-data-key) for details.
  """
  def generate_data_key(client, path, type, name, body, opts \\ []) do
    url_path =
      "v1/" <> uri_encode(path) <> "/datakey/" <> uri_encode(type) <> "/" <> uri_encode(name)

    client
    |> Tesla.post(url_path, body, opts)
    |> handle_response()
  end

  @doc """
  Encrypts data.

  See [Encrypt Data](https://www.vaultproject.io/api-docs/secret/transit#encrypt-data) for details.
  """
  def encrypt_data(client, path, name, body, opts \\ []) do
    url_path = "v1/" <> uri_encode(path) <> "/encrypt/" <> uri_encode(name)

    client
    |> Tesla.post(url_path, body, opts)
    |> handle_response()
  end

  @doc """
  Decrypts data.

  See [Decrypt Data](https://www.vaultproject.io/api-docs/secret/transit#decrypt-data) for details.
  """
  def decrypt_data(client, path, name, body, opts \\ []) do
    url_path = "v1/" <> uri_encode(path) <> "/decrypt/" <> uri_encode(name)

    client
    |> Tesla.post(url_path, body, opts)
    |> handle_response()
  end

  @doc """
  Rewrap data.

  See [Rewrap Data](https://www.vaultproject.io/api-docs/secret/transit#rewrap-data) for details.
  """
  def rewrap_data(client, path, name, body, opts \\ []) do
    url_path = "v1/" <> uri_encode(path) <> "/rewrap/" <> uri_encode(name)

    client
    |> Tesla.post(url_path, body, opts)
    |> handle_response()
  end
end
