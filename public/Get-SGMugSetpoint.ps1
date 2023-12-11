filter parseSetpointTemp {
    $temp = ($_ -replace 'temperature=', '').Trim()
    [pscustomobject]@{
        Setpoint_Temperature_F = [int]::Parse($temp)
    }
}

function Get-SGMugSetpoint {
    [CmdletBinding()]
    param ()
    Test-SGMugConnection
    Write-GATTValue -TextValue 'gettemperature'
    Start-Sleep -Milliseconds 100
    while ($SyncHash.responseText -notlike 'temperature=*') {
        Start-Sleep -Milliseconds 100
    }
    $SyncHash.responseText | parseSetpointTemp | Write-Output
}