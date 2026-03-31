$sshKey = "C:\vagrant\.vagrant\machines\test\virtualbox\private_key"
$sshCommonArgs = @(
  "-i", $sshKey,
  "-o", "StrictHostKeyChecking=no",
  "-o", "UserKnownHostsFile=/dev/null",
  "-o", "ExitOnForwardFailure=yes",
  "-o", "ServerAliveInterval=30",
  "-o", "ServerAliveCountMax=3",
  "vagrant@192.168.56.10"
)

$tunnels = @(
  @{
    Name = "student-browser-tunnel"
    Port = 3000
    RemotePort = 3000
  },
  @{
    Name = "prometheus-browser-tunnel"
    Port = 9090
    RemotePort = 9090
  }
)

foreach ($tunnel in $tunnels) {
  $existing = Get-CimInstance Win32_Process |
    Where-Object {
      $_.Name -eq "ssh.exe" -and
      $_.CommandLine -like "*127.0.0.1:$($tunnel.Port):127.0.0.1:$($tunnel.RemotePort)*"
    }

  if ($existing) {
    continue
  }

  $args = @(
    "-N",
    "-L", "127.0.0.1:$($tunnel.Port):127.0.0.1:$($tunnel.RemotePort)"
  ) + $sshCommonArgs

  Start-Process -FilePath "ssh.exe" -ArgumentList $args -WindowStyle Hidden
}

Start-Sleep -Seconds 2

foreach ($tunnel in $tunnels) {
  try {
    $result = Test-NetConnection -ComputerName 127.0.0.1 -Port $tunnel.Port -WarningAction SilentlyContinue
    "{0}:{1} {2}" -f "127.0.0.1", $tunnel.Port, $result.TcpTestSucceeded
  } catch {
    "{0}:{1} False" -f "127.0.0.1", $tunnel.Port
  }
}
