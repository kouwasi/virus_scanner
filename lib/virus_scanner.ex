defmodule VirusScanner do
  use Application
  alias Alchemy.Client

  @token Application.get_env(:virus_scanner, :token)

  def start(_type, _args) do
    run = Client.start(@token)
    use VirusScanner.OnMessage
    run
  end
end