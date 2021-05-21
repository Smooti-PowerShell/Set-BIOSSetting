<#
    .DESCRIPTION
        Automatically configure BIOS settings
        SetBIOSSetting Return Codes
        0 - Success
        1 - Not Supported
        2 - Unspecified Error
        3 - Timeout
        4 - Failed - (Check for typos in the setting value)
        5 - Invalid Parameter
        6 - Access Denied - (Check that the BIOS password is correct)
    .NOTES
        Author: Robert Owens
        Created: December 30, 2020
#>
param (
    [Parameter(mandatory=$true)]
    [string] $Setting,
    [Parameter(mandatory=$true)]
    [string] $Value
)
$ErrorActionPreference = "SilentlyContinue"
Import-Module -Name "$($PSScriptRoot)\Modules\MasterFunctions"

function Set-HP_BIOS
{
    param(
        [string]$Password = $null,
        [string]$setting = $null,
        [string]$Value = $null
    )
    $check_passwordset = (gwmi -Namespace root/hp/instrumentedBIOS -Class hp_biossetting | Where-Object {$_.Name -eq "Setup Password"}).IsSet
    $bios = gwmi -NameSpace root/hp/instrumentedBIOS -Class HP_BIOSSettingInterface

    try 
    {
        if ($setting -eq "" -or $Value -eq "")
        {
            throw 'The "Setting" and "Value" flag must both be set.'
        }

        # Check if Password for BIOS is on
        if ($check_passwordset -eq 1)
        {
            $utf_password = "<utf-16/>" + $Password
            $set_setting = $bios.setbiossetting($setting, $Value, $utf_password)
            $return_code = $set_setting.return
            if ($return_code -eq 0)
            {
                Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
            }
            else
            {
                throw "Couldn't change setting $($setting) (Return Code $($return_code))"
            }
        }
        else
        {
            $set_setting = $bios.setbiossetting($setting, $Value, "")
            $return_code = $set_setting.return
    
            if ($return_code -eq 0)
            {
                Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
            }
            else
            {
                throw "Couldn't change setting $($setting) (Return Code $($return_code))"
            }
        }
    }
    catch
    {
        Write-Host "$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black
    }
}

function Set-Dell_BIOS
{
    param(
        [string]$Password,
        [string]$setting = $null,
        [string]$Value = $null
    )
    try {
        $check_passwordset = (Get-DellBiosSettings | Where Attribute -EQ "IsAdminPasswordSet").CurrentValue
        $attr_local = (Get-DellBiosSettings | Where Attribute -EQ "$($setting)").PSPath.Replace("DellBIOSProvider\DellSmbiosProv::","")
        if ($check_passwordset) {
            Set-Item -Path "$($attr_local)\$($setting)" $Value -Password $PASS
        }
        else {
            Set-Item -Path "$($attr_local)\$($setting)" $Value
        }
    }
    Catch {
        Write-Host "Unable to access BIOS." -ForegroundColor Red -BackgroundColor Black
        Write-Host "Check BIOS Password." -ForegroundColor Cyan
        Exit
    }
}

function Set-Lenovo_BIOS
{
    param(
        [string]$Password,
        [string]$setting = $null,
        [string]$Value = $null
    )
    $check_passwordset = (gwmi -Namespace root/wmi -Class Lenovo_BiosPasswordSettings | Where-Object {$_.Name -eq "Setup Password"}).IsSet
    $bios = gwmi -NameSpace root/wmi -Class LenovoSetBiosSetting
    $save_bios = (gwmi -Namespace root/wmi -Class Lenovo_SaveBiosSettings)

    # Check if Password for BIOS is on
    try 
    {
        if ($check_passwordset -eq 1)
        {
            $utf_password = "<utf-16/>" + $Password
            $set_setting = $bios.setbiossetting($setting, $Value, $utf_password, "ascii", "us")
            $return_code = $set_setting.return
            $save_bios.SaveBiosSettings($utf_password, "ascii", "us")
            if ($return_code -eq 0)
            {
                Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
            }
            else
            {
                throw "Couldn't change setting $($setting) (Return Code $($return_code))"
            }
        }
        else
        {
            $set_setting = $bios.setbiossetting($setting, $Value, "")
            $return_code = $set_setting.return
            $save_bios.SaveBiosSettings()
    
            if ($return_code -eq 0)
            {
                Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
            }
            else
            {
                throw "Couldn't change setting $($setting) (Return Code $($return_code))"
            }
        }
    }
    catch
    {
        Write-Host "$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black
    }
}

switch (Get-Manufacturer)
{
    "HP"
    {
        Set-HP_BIOS -setting $Setting -value $Value -Password $PASS
    }
    "DELL"
    {
        Import-Module -Name "$($PSScriptRoot)\Modules\DellBIOSProvider"
        Set-Dell_BIOS -Setting $Setting -value $Value -Password $PASS
    }
    "Lenovo"
    {
        Set-Lenovo_BIOS -Setting $Setting -value $Value -Password $PASS
    }
}
