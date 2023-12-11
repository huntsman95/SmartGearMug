function Disconnect-SGMug {
    [CmdletBinding()]
    param ()
    $SyncHash.gattservices.Services | ForEach-Object {
        $_.Dispose()
    }
    $SyncHash.gattservices = $null
    $SyncHash.bledevice.Dispose()
    $SyncHash.bledevice = $null
}