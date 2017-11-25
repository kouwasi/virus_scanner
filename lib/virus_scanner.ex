defmodule VirusScanner do
  use Application
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def ping do
      Cogs.say "pong!"
    end
  end

  def start(_type, _args) do
    run = Client.start("your token here")
    use Commands
    run
  end
end