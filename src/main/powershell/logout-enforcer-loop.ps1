$screentime_host = 'bubba.'

function Test-Screentime-User {
    param ($user, [bool] $just_logged_in)

    if ($user -in "emil","henry") {
        try {
            $response = Invoke-WebRequest -URI "http://$screentime_host/x/screentime?$user" -UseBasicParsing
            $mins_left = [int] $response.Content
        
            if ($mins_left -gt 0) {
                if ($mins_left -eq 1) {
                    $speaker.Speak("You have one minute left.")
                } elseif ($just_logged_in -or ($mins_left%10 -eq 0) -or ($mins_left -eq 5)) {
                    $speaker.Speak("You have $mins_left minutes left.")
                }
                return $false
            } elseif (-not $just_logged_in) { 
                $countDown.playsync() 
            }
        } catch [System.Net.WebException] {
            $speaker.Speak("Network request for remaining screen time failed")
        }
        logoff console
        return $true
    } else {
        return $just_logged_in
    }
}

Add-Type -AssemblyName System.Speech
$speaker = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$countDown = New-Object System.Media.SoundPlayer
$countDown.SoundLocation = 'C:\Logins\countdown.wav'

$seconds_per_minute = 60

[bool] $first = $true

try {
    $watcher = New-Object -TypeName System.IO.FileSystemWatcher -Property @{
        Path = 'C:\Users\Public' 
        Filter = 'login.txt'
    } 
    while ($true) {
        $time = Get-Date
        $quser_console = quser console 

        if ($quser_console -eq "No User exists for console") {
            $first = $true
        } else {
            $users = $quser_console -ireplace '\s{2,}',',' | ConvertFrom-Csv
            foreach ($user in $users) {
                if ($user.state -eq "Active") {
                    $first = (Test-Screentime-User ($user.USERNAME -replace '>','') $first)
                }
            }
        }
        $now = Get-Date
        $time_passed= New-TimeSpan -Start $time -End $now
        $secs_to_sleep = $seconds_per_minute - $time_passed.Seconds 
        $watcher.WaitForChanged('All', $secs_to_sleep * 1000)
    }
} finally {
    $watcher.dispose()
}