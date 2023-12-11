filter parseNtcTemp {
    [int]$temp = $_ -replace 'ntc=', ''
    [pscustomobject]@{
        Liquid_Temperature_F = $temp
    }
}

function Get-SGMugLiquidTemperature {
    [CmdletBinding()]
    param ()
    Test-SGMugConnection
    Write-GATTValue -TextValue 'getntc'
    Start-Sleep -Milliseconds 100
    while ($SyncHash.responseText -notlike 'ntc=*') {
        Start-Sleep -Milliseconds 100
    }
    $SyncHash.responseText | parseNtcTemp | Write-Output
}