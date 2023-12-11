filter parsePowerState {
    [int]$powerSource = $_ -replace 'power=', ''
    $stateDict = @{
        0 = 'Coaster'
        1 = 'Battery'
    }
    [pscustomobject]@{
        Power_Source = $stateDict[$powerSource]
    }
}

function Get-SGMugPowerSource {
    Test-SGMugConnection
    try {
        Write-GATTValue -TextValue 'getpower'
    }
    catch {
        Write-Host 'fail'
    }
    Start-Sleep -Milliseconds 100
    while ($SyncHash.responseText -notlike 'power=*') {
        Start-Sleep -Milliseconds 100
    }
    $SyncHash.responseText | parsePowerState | Write-Output
}