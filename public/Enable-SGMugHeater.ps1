function Enable-SGMugHeater {
    Test-SGMugConnection
    Write-GATTValue -TextValue 'thermostaton'
    Start-Sleep -Milliseconds 100
    $state = Get-SGMugState
    if ($state.Heater_State -ne 'Enabled') {
        Write-Error 'Failed to enable coffee mug heater'
    }
}