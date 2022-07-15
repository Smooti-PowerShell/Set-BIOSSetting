function Get-Manufacturer {
	$manufacturer = (Get-WmiObject Win32_Computersystem).manufacturer
	return $manufacturer
}

function Get-BIOSSettings {
	if (Get-Manufacturer -like "*HP*") {
		$settings = Get-WmiObject -Namespace root\HP\InstrumentedBIOS -Class HP_BIOSEnumeration | Select-Object Name, Value
	}
	elseif (Get-Manufacturer -like "*DELL*") {
		$settings = Get-DellBiosSettings
	}
	elseif (Get-Manufacturer -like "*lenovo*") {
		$settings = Get-WmiObject -Namespace root\wmi -Class Lenovo_BiosSetting | Select-Object CurrentSetting
	}
	else {
		throw "$(Get-Manufacturer) not supported."
	}

	return $settings
}

function Set-HPBIOSSetting {
	param(
		[securestring]$Password = $null,
		[string]$setting = $null,
		[string]$Value = $null
	)

	# * Convert secure-string to plain text
	if ($null -ne $Password) {
		$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
		$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
	}

	$check_passwordset = (Get-WmiObject -Namespace root/hp/instrumentedBIOS -Class hp_biossetting | Where-Object-Object { $_.Name -eq "Setup Password" }).IsSet
	$bios = Get-WmiObject -NameSpace root/hp/instrumentedBIOS -Class HP_BIOSSettingInterface

	try {
		if ($setting -eq "" -or $Value -eq "") {
			throw 'The "Setting" and "Value" flag must both be set.'
		}

		# Check if Password for BIOS is on
		if ($check_passwordset -eq 1) {
			$utf_password = "<utf-16/>" + $Password
			$set_setting = $bios.setbiossetting($setting, $Value, $utf_password)
			$return_code = $set_setting.return
			if ($return_code -eq 0) {
				Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
			}
			else {
				throw "Couldn't change setting $($setting) (Return Code $($return_code))"
			}
		}
		else {
			$set_setting = $bios.setbiossetting($setting, $Value, "")
			$return_code = $set_setting.return
    
			if ($return_code -eq 0) {
				Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
			}
			else {
				throw "Couldn't change setting $($setting) (Return Code $($return_code))"
			}
		}
	}
	catch {
		Write-Host "$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black
	}
}

function Set-DellBIOSSetting {
	param(
		[securestring]$Password = $null,
		[string]$setting = $null,
		[string]$Value = $null
	)

	# * Convert secure-string to plain text
	if ($null -ne $Password) {
		$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
		$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
	}

	try {
		$check_passwordset = (Get-DellBiosSettings | Where-Object Attribute -EQ "IsAdminPasswordSet").CurrentValue
		$attr_local = (Get-DellBiosSettings | Where-Object Attribute -EQ "$($setting)").PSPath.Replace("DellBIOSProvider\DellSmbiosProv::", "")
		if ($check_passwordset) {
			Set-Item -Path "$($attr_local)\$($setting)" $Value -Password $Password
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

function Set-LenovoBIOSSetting {
	param(
		[securestring]$Password = $null,
		[string]$setting = $null,
		[string]$Value = $null
	)

	# * Convert secure-string to plain text
	if ($null -ne $Password) {
		$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
		$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
	}

	$check_passwordset = (Get-WmiObject -Namespace root/wmi -Class Lenovo_BiosPasswordSettings | Where-Object-Object { $_.Name -eq "Setup Password" }).IsSet
	$bios = Get-WmiObject -NameSpace root/wmi -Class LenovoSetBiosSetting
	$save_bios = (Get-WmiObject -Namespace root/wmi -Class Lenovo_SaveBiosSettings)

	# Check if Password for BIOS is on
	try {
		if ($check_passwordset -eq 1) {
			$utf_password = "<utf-16/>" + $Password
			$set_setting = $bios.setbiossetting($setting, $Value, $utf_password, "ascii", "us")
			$return_code = $set_setting.return
			$save_bios.SaveBiosSettings($utf_password, "ascii", "us")
			if ($return_code -eq 0) {
				Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
			}
			else {
				throw "Couldn't change setting $($setting) (Return Code $($return_code))"
			}
		}
		else {
			$set_setting = $bios.setbiossetting($setting, $Value, "")
			$return_code = $set_setting.return
			$save_bios.SaveBiosSettings()
    
			if ($return_code -eq 0) {
				Write-Host "$setting has been set to $Value" -ForegroundColor Cyan
			}
			else {
				throw "Couldn't change setting $($setting) (Return Code $($return_code))"
			}
		}
	}
	catch {
		Write-Host "$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black
	}
}