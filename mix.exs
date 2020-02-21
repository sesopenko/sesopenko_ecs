defmodule Sesopenko.ECS.MixProject do
  use Mix.Project

  def project do
    [
      app: :sesopenko_ecs,
      version: "0.1.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "sesopenko ECS",
      source_url: "https://github.com/sesopenko/sesopenko_ecs"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "This is an implementation of the Entity Component System software structural architecture, aimed towards game server development in Elixir."
  end

  defp package do
    [
      name: "sesopenko_ecs",
      files: ~w(lib .formatter.exs mix.exs README*  LICENSE*),
      licenses: ["GNU-GPLv3.0"],
      links: %{"GitHub" => "https://github.com/sesopenko/sesopenko_ecs"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_uuid, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
