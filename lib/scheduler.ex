defmodule VirusScanner.Scheduler do
  use Quantum.Scheduler,
    otp_app: :virus_scanner
end