using module .\lib\WinRT.Runtime.dll
using module .\lib\Microsoft.Windows.SDK.NET.dll

using namespace Windows.Devices.Bluetooth
using namespace Windows.Devices.Bluetooth.Advertisement
using namespace Windows.Devices.Enumeration

#requires -version 7.0

. "$PSScriptRoot\private\winrtasync.ps1"
. "$PSScriptRoot\private\writegatt.ps1"
. "$PSScriptRoot\private\checkconnection.ps1"

$Global:SyncHash = [hashtable]::Synchronized(@{})
$SyncHash.bleaddr = $null

$public = Get-ChildItem "$PSScriptRoot\public\" -Filter '*.ps1' -Recurse
$public | ForEach-Object {
    . $_.FullName
}