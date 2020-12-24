function Get-Manufacturer
{
    $manufacturer = (gwmi Win32_Computersystem).manufacturer
    try
    {
        if ($manufacturer -like "*HP*" -or $manufacturer -like "*hewlet*")
        {
            return "HP"
        }
        elseif ($manufacturer -like "*dell*")
        {
            return "DELL"
        }
        elseif ($manufacturer -like "*lenovo*")
        {
            return "Lenovo"
        }
        else {
            {
                throw "$($manufacturer) not supported."
            }
        }
    }
    catch
    {
        Write-Host "$($_.Exception.Message)" -Foreground red -Background Black
    }
}

function Get-BIOSSettings
{
    switch (Get-Manufacturer)
    {
        "HP"
        {
            $settings = gwmi -Namespace root\HP\InstrumentedBIOS -Class HP_BIOSEnumeration | Select Name, Value
            return $settings
        }
        "DELL"
        {
            $settings = Get-DellBiosSettings
            return $settings
        }
        "Lenovo"
        {
            $settings = gwmi -Namespace root\wmi -Class Lenovo_BiosSetting | Select CurrentSetting
            return $settings
        }
    }
}
