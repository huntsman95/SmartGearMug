function Set-SGMugSetpoint {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet(120, 125, 130, 135, 140, 145, 150, 155, 160)]
        [int]
        $Temperature
    )
    Test-SGMugConnection
    Write-GATTValue -TextValue ('settemperature=' + $Temperature.ToString())
    Start-Sleep -Milliseconds 100
    Get-SGMugSetpoint
}