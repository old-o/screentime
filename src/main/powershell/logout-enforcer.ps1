$screentime_host = 'bubba.'
$screentime_admin = 'voldemort'
$seconds_per_minute = 60

$user = (whoami).split("\")[1].ToLower()

if ($user -eq "$screentime_admin") {
   exit
}

Add-Type -AssemblyName System.Speech
$speaker = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer

try {
    do {
        $response = Invoke-WebRequest -URI "http://$screentime_host/x/screentime?$user" -UseBasicParsing
        $remaining_minutes = [int] $response.Content
        [bool] $time_left = ( $remaining_minutes -gt 0 )
        if ( $time_left ) {
            $speaker.Speak("You have $remaining_minutes minutes left")
            Start-Sleep -s $seconds_per_minute
            [bool] $countdown_required = $true
        } 
    } while ( $time_left )
} catch [System.Net.WebException] {
    $speaker.Speak("Network request for remaining screen time failed")
    Write-Error 'HTTP request for remaining login time failed'
}

if ( $countdown_required ) { 
   $soundPlayer = New-Object System.Media.SoundPlayer
   $soundPlayer.SoundLocation = 'C:\Logins\countdown.wav'
   $soundPlayer.playsync()
} 

shutdown /l /f

