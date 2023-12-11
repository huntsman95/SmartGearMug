filter parseSetpointTemp {
    [int]$temp = $_ -replace 'temperature=', ''
    [pscustomobject]@{
        Setpoint_Temperature_F = $temp
    }
}

function Get-SGMugSetpoint {
    Test-SGMugConnection
    Write-GATTValue -TextValue 'gettemperature'
    Start-Sleep -Milliseconds 100
    while ($SyncHash.responseText -notlike 'temperature=*') {
        Start-Sleep -Milliseconds 100
    }
    $SyncHash.responseText | parseSetpointTemp | Write-Output
}