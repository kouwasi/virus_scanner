defmodule VirusScanner.OnMessage do
  use Alchemy.Events

  Events.on_message(:scan)

  def scan(%Alchemy.Message{attachments: [%Alchemy.Attachment{url: url}]}) do
    regex = Regex.compile!("/\.gif$|\.png$|\.jpg$|\.jpeg$|\.bmp$/i")
    
    unless Regex.match?(regex, url) do
      IO.inspect url
    end
  end

  def scan(_msg), do: IO.inspect "on message"
end