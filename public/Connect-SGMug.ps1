function Connect-SGMug {
    [CmdletBinding()]
    param (
        #TODO
    )

    [guid]$Global:ServiceUUID = '6e400001-b5a3-f393-e0a9-e50e24dcca9e'

    try {
        #region adv_callback
        $GetBLEAdvDataFunction = {
            $inputObj = $Event.SourceArgs
            if ($inputObj.Advertisement.ServiceUuids -eq $ServiceUUID) {
                $SyncHash.bleaddr = $inputObj.BluetoothAddress
            }
        }
        #endregion

        #region conn_callback
        $ConnCallback = {
            $inputObj = $Event.SourceArgs
            switch ($inputObj.ConnectionStatus) {
                'Disconnected' {
                    Write-Host 'Disconnected from SG Mug'
                    Disconnect-SGMug
                    # Start-Sleep -Milliseconds 1000
                    # Connect-SGMug
                }
            
                Default {
                    # Write-Host "Unhandled event: $($inputObj.ConnectionStatus.ToString())"
                }
            }
        }
        #endregion

        #region start watcher
        Get-EventSubscriber | Unregister-Event

        $watcher = [BluetoothLEAdvertisementWatcher]::new()
        $watcher.ScanningMode = 1 #Active scanning to retrieve manufacturer data containing humidity/temp data

        $advEvent = Register-ObjectEvent -InputObject $watcher -EventName 'Received' -Action $GetBLEAdvDataFunction | Out-Null

        $watcher.Start()

        Write-Host 'Connecting' -NoNewline
        while ($true) {
            Write-Host '.' -NoNewline
            Start-Sleep -Milliseconds 100
            if ($null -ne $SyncHash.bleaddr) {
                $watcher.Stop()
                [BluetoothLEDevice]$SyncHash.bledevice = [BluetoothLEDevice]::FromBluetoothAddressAsync($SyncHash.bleaddr) | Wait-WinRTAsync -OutputType ([Windows.Devices.Bluetooth.BluetoothLEDevice])
                $SyncHash.bleaddr = $null
                Register-ObjectEvent -InputObject $SyncHash.bledevice -EventName 'ConnectionStatusChanged' -Action $ConnCallback | Out-Null
                $SyncHash.gattservices = $SyncHash.bledevice.GetGattServicesAsync() | Wait-WinRTAsync -OutputType ([Windows.Devices.Bluetooth.GenericAttributeProfile.GattDeviceServicesResult])
                # Register Notify on GATT Characteristic Change
                $SyncHash.gatchar = ($SyncHash.gattservices.Services[2]).GetCharacteristicsAsync() | Wait-WinRTAsync -OutputType ([Windows.Devices.Bluetooth.GenericAttributeProfile.GattCharacteristicsResult])
            ($SyncHash.gatchar.Characteristics[0]).WriteClientCharacteristicConfigurationDescriptorAsync(([Windows.Devices.Bluetooth.GenericAttributeProfile.GattClientCharacteristicConfigurationDescriptorValue]::Notify))`
                | Wait-WinRTAsync -OutputType ([Windows.Devices.Bluetooth.GenericAttributeProfile.GattCommunicationStatus]) | Out-Null
                Register-ObjectEvent ($SyncHash.gatchar.Characteristics[0]) -EventName ValueChanged -Action {
                    $mDataBytes = [System.Runtime.InteropServices.WindowsRuntime.WindowsRuntimeBufferExtensions].GetMethod('ToArray', [type[]]@([Windows.Storage.Streams.IBuffer])).Invoke($null, $Event.SourceArgs.CharacteristicValue)
                    $responseText = [System.Text.Encoding]::UTF8.GetString($mDataBytes)
                    $SyncHash.responseText = ($responseText)
                } | Out-Null

                Write-Host 'Connected'
                break
            }
            # $SyncHash.bledevice.
        }
    }
    finally {
        $advEvent | Unregister-Event
    }
    #endregion
}