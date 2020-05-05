defmodule ExVault.TokenServer do
  @moduledoc """
  A server to manage vault token.

  It holds the vault configuration including vault token in the state.
  """

  use GenServer

  require Logger

  @doc false
  defmacro __using__(opts) do
    quote location: :keep do
      def child_spec(init_arg) do
        default = %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [init_arg]}
        }

        Supervisor.child_spec(default, [])
      end

      @doc false
      def __opts__ do
        Keyword.put_new(unquote(opts), :name, __MODULE__)
      end

      @doc """
      Returns a client for `Vault`.
      """
      def build_client do
        GenServer.call(Keyword.fetch!(__opts__(), :name), :build_client)
      end

      def start_link(init_args) do
        GenServer.start_link(
          ExVault.TokenServer,
          init_args,
          name: Keyword.fetch!(__opts__(), :name)
        )
      end
    end
  end

  @impl GenServer
  def init(args) do
    config = struct!(ExVault.Config, Keyword.fetch!(args, :config))
    {:ok, %{config: config, token: nil}, {:continue, :login}}
  end

  @impl GenServer
  def handle_continue(:login, %{config: config} = state) do
    %ExVault.Config{auth: auth} = config

    case state |> build_client() |> get_token(auth) do
      {:ok, token} ->
        {:noreply, state |> Map.put(:token, token), {:continue, :lookup_self}}

      {:error, error} ->
        Logger.error("failed to authenticate", error: inspect(error))
        {:stop, :normal, state}
    end
  end

  def handle_continue(:lookup_self, state), do: lookup_token_and_schedule_renew(state)

  @impl GenServer
  def handle_call(:build_client, _from, state),
    do: {:reply, build_client(state), state}

  @impl GenServer
  def handle_info(:renew, state) do
    Logger.info("renewing token")

    case state |> build_client() |> ExVault.Auth.Token.renew_self(%{}) do
      {:ok, %{status: 200, body: %{"auth" => _}}} ->
        lookup_token_and_schedule_renew(state)

      {:ok, %{body: body}} ->
        Logger.error("failed to renew token", error_resp_body: body)
        {:noreply, state}

      {:error, error} ->
        Logger.error("failed to renew token", error: inspect(error))
        {:stop, :normal, state}
    end
  end

  defp get_token(_client, {ExVault.Auth.Token, %{token: token}}), do: {:ok, token}

  defp get_token(client, {ExVault.Auth.Kubernetes, opts}) do
    case ExVault.Auth.Kubernetes.login(client, read_jwt(opts)) do
      {:ok, %{body: %{"auth" => %{"client_token" => token}}}} -> {:ok, token}
      {_, other} -> {:error, other}
    end
  end

  defp read_jwt(%{jwt_path: jwt_path} = opts) do
    opts
    |> Map.delete(:jwt_path)
    |> Map.put(:jwt, File.read!(jwt_path))
  end

  def lookup_token_and_schedule_renew(state) do
    case state |> build_client() |> ExVault.Auth.Token.lookup_self() do
      {:ok, %{status: 200, body: %{"data" => %{"renewable" => true, "expire_time" => exp_str}}}} ->
        {:ok, exp_dt, _} = DateTime.from_iso8601(exp_str)
        delay_ms = DateTime.diff(exp_dt, DateTime.utc_now(), :millisecond)
        Logger.info("scheduling renew", delay_ms: delay_ms)
        Process.send_after(self(), :renew, delay_ms)
        {:noreply, state}

      {:ok, %{status: 200, body: %{"data" => _}}} ->
        {:noreply, state}

      {:error, error} ->
        Logger.error("failed to look up token", error: inspect(error))
        {:stop, :normal, state}
    end
  end

  defp build_client(%{config: config, token: token} = _state),
    do: ExVault.build_client(config, token)
end
