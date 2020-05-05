defmodule ExVault.Config do
  @moduledoc """
  Configuration for `Vault`.
  """

  @type t :: %__MODULE__{
          addr: String.t(),
          auth: {module, map}
        }

  defstruct [:addr, :auth]
end
