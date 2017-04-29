defmodule WaterCooler.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, WaterCooler, [],
        port: 8080,
      ),
      Plug.Adapters.Cowboy.child_spec(:https, WaterCooler, [],
        port: 8443,
        otp_app: :water_cooler,
        keyfile: "priv/localhost.key",
        certfile: "priv/localhost.cert",
      ),
    ]

    opts = [strategy: :one_for_one, name: WaterCooler.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
