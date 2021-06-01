import Config

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_pack],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger, RamoopsLogger]

# Configure Livebook
config :livebook, LivebookWeb.Endpoint,
  url: [host: "nerves.local"],
  http: [
    port: "80",
    transport_options: [socket_opts: [:inet6]]
  ],
  code_reloader: false,
  server: true,
  secret_key_base: "9hHHeOiAA8wrivUfuS//jQMurHxoMYUtF788BQMx2KO7mYUE8rVrGGG09djBNQq7"

config :livebook,
  root_path: "/data/livebooks"

# Nerves Runtime can enumerate hardware devices and send notifications via
# SystemRegistry. This slows down startup and not many programs make use of
# this feature.

config :nerves_runtime, :kernel, use_system_registry: false

config :blue_heron, log_hci_dump_file: false

# Erlinit can be configured without a rootfs_overlay. See
# https://github.com/nerves-project/erlinit/ for more information on
# configuring erlinit.

config :nerves, :erlinit,
  hostname_pattern: "nerves-%s",
  shutdown_report: "/data/last_shutdown.txt"

# Configure the device for SSH IEx prompt access and firmware updates
#
# * See https://hexdocs.pm/nerves_ssh/readme.html for general SSH configuration
# * See https://hexdocs.pm/ssh_subsystem_fwup/readme.html for firmware updates

key_paths =
  [
    ".ssh/id_rsa.pub",
    ".ssh/id_desktop_rsa.pub",
    ".ssh/id_laptop_rsa.pub",
    ".ssh/id_nerves.pub",
    ".ssh/id_air_laptop.pub"
  ]
  |> Enum.map(fn path -> Path.join(System.user_home!(), path) end)

authorized_keys =
  key_paths
  |> Enum.filter(&File.exists?/1)
  |> Enum.map(&File.read!/1)

config :nerves_ssh,
  authorized_keys: authorized_keys,
  user_passwords: [{"livebook", "nerves"}, {"root", "nerves"}],
  daemon_option_overrides: [
    {:auth_method_kb_interactive_data,
     {'Nerves Livebook',
      'https://github.com/fhunleth/nerves_livebook\n\nssh livebook@nerves.local # Use password "nerves"\n',
      'Password: ', false}}
  ]

config :mdns_lite,
  # The `host` key specifies what hostnames mdns_lite advertises.  `:hostname`
  # advertises the device's hostname.local. For the official Nerves systems, this
  # is "nerves-<4 digit serial#>.local".  mdns_lite also advertises
  # "nerves.local" for convenience. If more than one Nerves device is on the
  # network, delete "nerves" from the list.

  host: [:hostname, "nerves"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      name: "SSH Remote Login Protocol",
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      name: "Secure File Transfer Protocol over SSH",
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      name: "Erlang Port Mapper Daemon",
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

import_config "#{Mix.target()}.exs"
