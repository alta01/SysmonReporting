##TO BE RUN IN POWERSHELL 7.0##
##USES THE PARALLEL SWITCH TO ITERATE THROUGH THE AD LIST IN PARALLEL RUNSPACES##

##Set Execution-Policy scope to the current Powershell process
Set-ExecutionPolicy Unrestricted -Scope Process -Force
$ad = (Get-ADComputer -Filter *).Name
$ad | ForEach-Object -Parallel{
$x = $_
    if(Invoke-Command -ComputerName $x -ScriptBlock {(Get-Service -Name sysmon -ErrorAction SilentlyContinue -Verbose).Status -eq "running"})
    {
        $running = "$x is currently RUNNING" | Out-File -FilePath $env:HOMEDRIVE\$env:HOMEPATH\Desktop\sysmonsuccess.log -Encoding UTF-8 -Append -Force
    }

    elseif(Invoke-Command -ComputerName $x -ScriptBlock {(Get-Service -Name sysmon -ErrorAction SilentlyContinue -Verbose).Status -eq "stopped"})
    {
        $stopped = "$x is currently STOPPED" | Out-File -FilePath $env:HOMEDRIVE\$env:HOMEPATH\Desktop\sysmonfailure.log -Encoding UTF-8 -Append -Force
    }
    else
    {
        $failed = "$x is not currently running sysmon" | Out-File -FilePath $env:HOMEDRIVE\$env:HOMEPATH\Desktop\sysmonfailure.log -Encoding UTF-8 -Append -Force
    }
} -ThrottleLimit 20