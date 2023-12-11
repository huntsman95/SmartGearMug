function Write-GATTValue {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TextValue
    )

    $DataByteArray = [System.Text.Encoding]::UTF8.GetBytes($TextValue)
    $DataBuffer = [System.Runtime.InteropServices.WindowsRuntime.WindowsRuntimeBufferExtensions]::AsBuffer($DataByteArray)

($SyncHash.gatchar.Characteristics[1]).WriteValueWithResultAsync($DataBuffer, ([Windows.Devices.Bluetooth.GenericAttributeProfile.GattWriteOption]::WriteWithResponse)) `
    | Wait-WinRTAsync -OutputType ([Windows.Devices.Bluetooth.GenericAttributeProfile.GattWriteResult]) | Out-Null
}