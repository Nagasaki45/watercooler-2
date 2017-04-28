defmodule WaterCooler.Mixfile do
  use Mix.Project

  def project do
    [app: :water_cooler,
     version: "0.0.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {WaterCooler, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"},
      {:gproc, "0.3.1"}
    ]
  end
end
