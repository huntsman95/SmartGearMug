filter parseBatteryValue {
    [int]$battery = $_ -replace 'batter=', ''
    [pscustomobject]@{
        Battery_Level_Percentage = $battery
    }
}

function Get-SGMugBatteryLevel {
    Test-SGMugConnection
    Write-GATTValue -TextValue 'getbatter'
    Start-Sleep -Milliseconds 100
    while ($SyncHash.responseText -notlike 'batter=*') {
        Start-Sleep -Milliseconds 100
    }
    $SyncHash.responseText | parseBatteryValue | Write-Output
}