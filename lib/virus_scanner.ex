defmodule VirusScanner do
  use Application
  alias Alchemy.Client

  @token Application.get_env(:virus_scanner, :discord_token)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(VirusScanner, []),
      worker(VirusScanner.Scheduler, [])
    ]
    
    opts = [strategy: :one_for_one, name: YourApp.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def start_link() do
    init_storage()
    run = Client.start(@token)
    use VirusScanner.OnMessage
    run
  end

  def init_storage() do
    :ets.new(:virus_scanner, [:named_table, :public, :set])
  end
end