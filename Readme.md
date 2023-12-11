# SmartGearMug PWSH Module

## Description
The SmartGearMug module for PowerShell is a PowerShell module that allows you to interact with the SmartGear Heated Coffee Mug Bluetooth Low Energy device as sold here: https://www.kohls.com/product/prd-6372399/smart-gear-temperature-control-smart-mug.jsp?skuid=80598038

This allows control over the device without installing chinese software on your phone infested with potentially malicious SDKs.

## Installation
`git clone` this repo to your PWSH `Modules` folder

## Requirements
- PowerShell 7.0 or higher

## Bundled Dependencies
- Windows SDK
- WinRT Runtime

## Usage

### Import the module
```PowerShell
Import-Module SmartGearMug
```

### Connect to the device
```PowerShell
Connect-SGMug
```

### Disconnect from the device
```PowerShell
Disconnect-SGMug
```

### Get the current temperature of your drink
```PowerShell
Get-SGMugLiquidTemperature

Liquid_Temperature_F
--------------------
                 149
```

### Get the current temperature setpoint
```PowerShell
Get-SGMugSetpoint

Setpoint_Temperature_F
----------------------
                   150
```

### Get the battery level of the smart mug
```PowerShell
Get-SGMugBatteryLevel

Battery_Level_Percentage
------------------------
                     100
```

### Set the temperature setpoint
```PowerShell
Set-SGMugSetpoint -Temperature 145

Setpoint_Temperature_F
----------------------
                   145
```

Etc.