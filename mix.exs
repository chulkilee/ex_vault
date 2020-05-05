defmodule ExVault.MixProject do
  use Mix.Project

  @version "0.0.1-dev"

  def project do
    [
      app: :ex_vault,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # hex
      description: "Simple wrapper for HashiCorp Vault",
      package: package(),

      # ex_doc
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.3"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/chulkilee/ex_vault",
        "Changelog" => "https://github.com/chulkilee/ex_vault/blob/master/CHANGELOG.md"
      },
      maintainers: ["Chulki Lee"]
    ]
  end

  defp docs do
    [
      name: "ExVault",
      source_ref: "v#{@version}",
      canonical: "https://hexdocs.pm/ex_vault",
      source_url: "https://github.com/chulkilee/ex_vault",
      nest_modules_by_prefix: [
        ExVault.Auth,
        ExVault.Secret
      ]
    ]
  end
end
