# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :nerves_livebook, target: Mix.target()

# Livebook configuration for host and target
config :livebook, LivebookWeb.Endpoint,
  pubsub_server: Livebook.PubSub,
  live_view: [signing_salt: "livebook"]

config :livebook,
  default_runtime: Livebook.Runtime.Embedded,
  authentication_mode: :password,
  token_authentication: false,
  password: System.get_env("LIVEBOOK_PASSWORD", "nerves")

config :livebook,
       :cookie,
       :nerves_livebook_cookie

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware,
  rootfs_overlay: "rootfs_overlay",
  fwup_conf: "config/fwup.conf"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1603310828"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

if Mix.target() == :host or Mix.target() == :"" do
  import_config "host.exs"
else
  import_config "target.exs"
end
