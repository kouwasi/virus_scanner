defmodule VirusScanner.OnMessage do
  use Alchemy.Events

  import Alchemy.Embed

  alias Alchemy.Embed
  alias Alchemy.User

  @virusTotalToken Application.get_env(:virus_scanner, :virus_total_token)

  Events.on_message(:scan)

  def scan(%Alchemy.Message{attachments: [%Alchemy.Attachment{url: url, filename: filename}], author: author, channel_id: channel_id}) do
    regex = Regex.compile!("/\.gif$|\.png$|\.jpg$|\.jpeg$|\.bmp$/i")
    
    message = %{
      channel_id: channel_id
    }

    unless Regex.match?(regex, url) do
      {_, result} = VirusTotal.Client.url_scan(@virusTotalToken, url)
      result = Enum.into(result, %{})

      if Map.get(result, "response_code") == 1 do
        :ets.insert(:virus_scanner, {Map.get(result, "scan_id"), filename, channel_id})
      end

      %Embed{}
        |> title("スキャンリクエストを送りました")
        |> description("ファイル名: #{filename}")
        |> author(name: author.username, icon_url: User.avatar_url(author))
        |> field("レスポンスコード", Map.get(result, "response_code"))
        |> field("レスポンスメッセージ", Map.get(result, "verbose_msg"))
        |> color(0x00ff00)
        |> Embed.send
    end
  end

  def scan(_msg), do: nil

  def check_reports() do
    :ets.match_object(:virus_scanner, {:"$1", :"_", :"_"})
      |> Enum.map(fn(x) -> get_report(x) end)
  end

  def get_report({scan_id, filename, channel_id}) do
    message = %{
      channel_id: channel_id
    }

    {:ok, report} = VirusTotal.Client.url_report(@virusTotalToken, scan_id)
    report = Enum.into(report, %{})

    if Map.get(report, "response_code") == 1 do
      %Embed{}
        |> title("スキャンが完了しました")
        |> description("ファイル名: #{filename}")
        |> field("レスポンスコード", Map.get(report, "response_code"), inline: true)
        |> field("検出数", Map.get(report, "positives"), inline: true)
        |> field("レスポンスメッセージ", Map.get(report, "verbose_msg"))
        |> color(0xff0000)
        |> Embed.send

      :ets.delete(:virus_scanner, scan_id)
    end
  end
end