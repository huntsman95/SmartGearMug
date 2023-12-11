function Disable-SGMugHeater {
    Test-SGMugConnection
    Write-GATTValue -TextValue 'thermostatoff'
    Start-Sleep -Milliseconds 100
    $state = Get-SGMugState
    if ($state.Heater_State -ne 'Disabled') {
        Write-Error 'Failed to disable coffee mug heater'
    }
    $state | Write-Output
}