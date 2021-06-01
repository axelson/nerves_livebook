defmodule NervesLivebook.MixProject do
  use Mix.Project

  @app :nerves_livebook
  @version "0.2.9"
  @all_targets [
    :rpi,
    :rpi0,
    :rpi2,
    :rpi3,
    :rpi3a,
    :rpi4,
    :bbb,
    :osd32mp1,
    :x86_64,
    :npi_imx6ull
  ]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.11",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  def application do
    [
      mod: {NervesLivebook.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  defp deps do
    [
      # Dependencies for host and target
      {:nerves, "~> 1.7.4", runtime: false},
      {:shoehorn, "~> 0.7.0"},
      {:ring_logger, "~> 0.8.1"},
      {:toolshed, "~> 0.2.13"},
      {:jason, "~> 1.2"},
      {:livebook, "~> 0.1.0", only: [:dev, :prod]},
      {:nerves_runtime, "~> 0.11.3"},
      {:nerves_pack, "~> 0.4.0"},
      {:nimble_options, "0.3.0"},

      # Dependencies for all targets except :host
      {:ramoops_logger, "~> 0.1", targets: @all_targets},
      {:blue_heron, github: "axelson/blue_heron", branch: "allow-disabling-logging", override: true},
      {:govee, github: "axelson/govee", targets: @all_targets},
      {:blue_heron_transport_uart, github: "blue-heron/blue_heron_transport_uart", branch: "main", targets: @all_targets},
      {:nerves_system_br, "~> 1.13.0", runtime: false, targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi3, "1.13.0", runtime: false, targets: :rpi3},
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: [keep: ["Docs"]]
    ]
  end
end
