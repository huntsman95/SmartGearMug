filter parseHeaterState {
    [int]$temp = $_ -replace 'state=', ''
    $stateDict = @{
        0 = 'Disabled'
        1 = 'Enabled'
    }
    [pscustomobject]@{
        Heater_State = $stateDict[$temp]
    }
}

function Get-SGMugState {
    [CmdletBinding()]
    param ()
    Test-SGMugConnection
    Write-GATTValue -TextValue 'getstate'
    Start-Sleep -Milliseconds 100
    while ($SyncHash.responseText -notlike 'state=*') {
        Start-Sleep -Milliseconds 100
    }
    $SyncHash.responseText | parseHeaterState | Write-Output
}