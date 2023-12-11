function Test-SGMugConnection {
    if ($null -eq $SyncHash.bledevice) {
        try { Disconnect-SGMug }
        catch {}
        Start-Sleep -Milliseconds 300
        Connect-SGMug
        Start-Sleep -Milliseconds 300
    }
}