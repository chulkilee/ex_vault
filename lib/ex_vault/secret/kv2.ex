defmodule ExVault.Secret.KV2 do
  @moduledoc """
  KV Secrets Engine - Version 2.

  - [KV Secrets Engine - Version 2 (API)](https://www.vaultproject.io/api-docs/secret/kv/kv-v2)
  """

  import ExVault.Utils

  @doc """
  Retrieves the secret at the specified location.

  See [Read Secret Version](https://www.vaultproject.io/api-docs/secret/kv/kv-v2#read-secret-version) for details.
  """
  def read_secret_version(client, engine_path, secret_path, opts \\ []) do
    case Tesla.get(
           client,
           "v1/" <> uri_encode(engine_path) <> "/data/" <> to_uri_path(secret_path),
           opts
         ) do
      {:ok, %{status: 200, body: %{"data" => _}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Creates or updates a secret.

  See [Create/Update Secret](https://www.vaultproject.io/api-docs/secret/kv/kv-v2#create-update-secret) for details.
  """
  def upsert_secret(client, engine_path, secret_path, body, opts \\ []) do
    case Tesla.post(
           client,
           "v1/" <> uri_encode(engine_path) <> "/data/" <> to_uri_path(secret_path),
           body,
           opts
         ) do
      {:ok, %{status: 200, body: %{"data" => _}} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  @doc """
  Deletes metadata and all versions.

  See [Delete Metadata and All Versions](https://www.vaultproject.io/api-docs/secret/kv/kv-v2#delete-metadata-and-all-versions) for details.
  """
  def delete_metadata_and_all_versions(client, engine_path, secret_path, opts \\ []) do
    case Tesla.delete(
           client,
           "v1/" <> uri_encode(engine_path) <> "/metadata/" <> to_uri_path(secret_path),
           opts
         ) do
      {:ok, %{status: 204} = resp} -> {:ok, resp}
      {_, other} -> {:error, other}
    end
  end

  defp to_uri_path(secret_path) when is_list(secret_path),
    do: secret_path |> Enum.map(&uri_encode/1) |> Enum.join("/")

  defp to_uri_path(secret_path), do: uri_encode(secret_path)
end
