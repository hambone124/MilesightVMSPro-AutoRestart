[CmdletBinding()]
Param()

$VMSFilePath = "C:\Program Files\Milesight VMS Pro\Milesight VMS Server\Milesight VMS Server.exe"
$ServerPortNumber = 33606

function Get-Time () {
    return Get-Date -Format "[yyyy-MM-dd HH:mm:ss]"
}

function Start-VMSServer () {
    Write-Verbose "$(Get-Time) Starting server..."
    
    Start-Process `
        -FilePath $VMSFilePath
        
    Write-Verbose "$(Get-Time) Server started."
}

function Get-VMSServerConnection () {
    $netstat = netstat -a -p udp
    $connections =  $netstat.trim() | `
    select -Skip 4 | `
    ConvertFrom-String `
        -PropertyNames Protocol,LocalAddress,RemoteAddress,State

    return $connections | `
        where LocalAddress -EQ "0.0.0.0:$ServerPortNumber"

}

while ($true) {

    Write-Verbose "$(Get-Time) Checking connection..."
        
    $VMSServer = Get-VMSServerConnection

    if ($VMSServer) {
        Write-Verbose "$(Get-Time) Server active."
    } elseif ($VMSServer -eq $null) {
        try {
            Write-Warning "$(Get-Time) Server not responding. Killing process."
            $process = Get-Process | `
                where ProcessName -eq "Milesight VMS Server"
            
            $process.Kill()

            Start-VMSServer
                       
        } 
        catch {
            Write-Warning "$(Get-Time) Process not found. Attempting to start..."
            try {
                Start-VMSServer
            }
            catch {
                Write-Warning "$(Get-Time) VMS Server could not be started"
            }
        }  
    }

    sleep 5
}
