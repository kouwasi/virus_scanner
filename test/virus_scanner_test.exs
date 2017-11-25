defmodule VirusScannerTest do
  use ExUnit.Case
  doctest VirusScanner

  test "greets the world" do
    assert VirusScanner.hello() == :world
  end
end
