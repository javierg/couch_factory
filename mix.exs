defmodule CouchFactory.Mixfile do
  use Mix.Project

  def project do
    [app: :couch_factory,
     version: "0.2.0",
     elixir: "~> 1.1",
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger, :couchbeam],
      mod: {CouchFactory, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev},
      {:couchbeam, git: "git://github.com/benoitc/couchbeam.git", tag: "1.1.8"}
    ]
  end

  defp description do
    """
      Factory Girl implementation with CouchDb persistence.
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Francisco J. Guerra"],
     licenses: ["MIT License"],
     links: %{"GitHub" => "https://github.com/javierg/couch_factory",
              "Docs" => "http://hexdocs.pm/couch_factory/0.1.0/"}
    ]
  end
end
