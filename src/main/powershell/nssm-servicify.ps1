$nssm = 'c:\users\public\home\tools\nssm\nssm.exe'
$powershell = (Get-Command Powershell).Source

$script = 'c:\users\public\home\tools\cygwin\home\voldemort\workspace\odoepner\screentime\src\main\powershell\logout-enforcer-loop.ps1'
$args = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $script
$service = 'logout-enforcer'

& $nssm install $service $powershell $args

