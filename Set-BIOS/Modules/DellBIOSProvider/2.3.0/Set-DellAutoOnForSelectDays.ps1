﻿function Set-DellAutoOnForSelectDays {
<#
  .Synopsis 
    Configures the system's auto-on capabilities that control individual days
  .Description
    This CmdLet sets the Auto-on to select days and enables or disables the individual days
    to automatically power on the system on a pre fixed .
	If a BIOS password (Admin or System password) is set, supply it using the -Password parameter. 
  .Example
    Set-DellAutoonForSelectDays -Sunday "Enabled" -Monday "Disabled" -password $Password
  .Example
	Set-DellAutoonForSelectDays -Tuesday "Enabled"
  .Example
    Set-DellAutoOnForSelectDays -verbose
#>
[CmdletBinding()]
param(  
    [Alias("Sun")][System.String] $Sunday,
    [Alias("Mon")][System.String] $Monday,
    [Alias("Tue")][System.String] $Tuesday,
    [Alias("Wed")][System.String] $Wednesday,
    [Alias("Thu")][System.String] $Thursday,
    [Alias("Fri")][System.String] $Friday,
    [Alias("Sat")][System.String] $Saturday,
    [Alias("pw")][Parameter(Mandatory=$false)][System.String] $Password
  
 )

 BEGIN { 
        Write-Output "Set-DellAutoOnForSelectDays"
 }
 PROCESS {
    #the process block is called for each item in the pipeline and you can reference it via $_
    #Write-Output "in process"

    $pathToPowerManagement = 'DellSmbios' + ':\' + 'PowerManagement'
    
    
    $isAdminPWSet  = Get-Item -path DellSmbios:\Security\IsAdminPasswordSet
    $issystemPWSet = Get-Item -path DellSmbios:\Security\IsSystemPasswordSet

    if (($isAdminPWSet.CurrentValue -match 'True') -or ($issystemPWSet.CurrentValue -match 'True')) 
    {
        if ([string]::IsNullOrEmpty($Password)){
        Write-Warning "Specify the password using -password."
        return
        }
    }

    
    if ($Password){
        Set-Item -path $pathToPowerManagement\AutoOn -value "SelectDays" -password $Password -ErrorVariable ev
    }
    else{   Set-Item -path $pathToPowerManagement\AutoOn -value "SelectDays" -ErrorVariable ev}

	if ($ev){
              Write-Warning "$ev Error occured in $($ev.InvocationInfo.ScriptName)"  
			  return
	}		
	
    if ($PSBoundParameters.ContainsKey('Sunday')) {
        if ($password){    
                Set-Item -path DellSmbios:\PowerManagement\AutoOnSun -value $Sunday -password $Password -ErrorVariable ev
         }
         else {Set-Item -path DellSmbios:\PowerManagement\AutoOnSun -value $Sunday -ErrorVariable ev}
        
    }
    if ($PSBoundParameters.ContainsKey('Monday')) {
         if ($password){ 
            Set-Item -path $pathToPowerManagement\AutoOnMon -value $Monday -password $Password -ErrorVariable ev
         }
         else {Set-Item -path DellSmbios:\PowerManagement\AutoOnMon -value $Monday -ErrorVariable ev}
    }
    if ($PSBoundParameters.ContainsKey('Tuesday')) {
         if ($password){ 
            Set-Item -path $pathToPowerManagement\AutoOnTue -value $Tuesday -password $Password -ErrorVariable ev
         }
         else {Set-Item -path DellSmbios:\PowerManagement\AutoOnTue -value $Tuesday -ErrorVariable ev}
    }
    if ($PSBoundParameters.ContainsKey('Wednesday')) {
         if ($password){ 
            Set-Item -path $pathToPowerManagement\AutoOnWed -value $Wednesday -password $Password -ErrorVariable ev
         }
         else {Set-Item -path DellSmbios:\PowerManagement\AutoOnWed -value $Wednesday -ErrorVariable ev}
    }
    if ($PSBoundParameters.ContainsKey('Thursday')) {
         if ($password){ 
            Set-Item -path $pathToPowerManagement\AutoOnThur -value $Thursday -password $Password -ErrorVariable ev
         }
         else {Set-Item -path DellSmbios:\PowerManagement\AutoOnThur -value $Thursday -ErrorVariable ev}
    }
    if ($PSBoundParameters.ContainsKey('Friday')) {
         if ($password){ 
            Set-Item -path $pathToPowerManagement\AutoOnFri -value $Friday -password $Password -ErrorVariable ev
         }
         else {Set-Item -path DellSmbios:\PowerManagement\AutoOnFri -value $Friday -ErrorVariable ev}
    }
     if ($PSBoundParameters.ContainsKey('Saturday')) {
         if ($password){ 
            Set-Item -path $pathToPowerManagement\AutoOnSat -value $Saturday -password $Password -ErrorVariable ev
         }
         else {Set-Item -path DellSmbios:\PowerManagement\AutoOnSat -value $Saturday -ErrorVariable ev}
    }
    if ($ev){
              Write-Warning "$ev Error occured in $($ev.InvocationInfo.ScriptName)"    		
	}			
  }
  END{}

  }


# SIG # Begin signature block
# MIIcOAYJKoZIhvcNAQcCoIIcKTCCHCUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBkCd2I324kNvJV
# cXRyVRisNACVvbOaR5pBrykHu9NLYqCCCscwggUyMIIEGqADAgECAg0Ah4JSYAAA
# AABR03PZMA0GCSqGSIb3DQEBCwUAMIG+MQswCQYDVQQGEwJVUzEWMBQGA1UEChMN
# RW50cnVzdCwgSW5jLjEoMCYGA1UECxMfU2VlIHd3dy5lbnRydXN0Lm5ldC9sZWdh
# bC10ZXJtczE5MDcGA1UECxMwKGMpIDIwMDkgRW50cnVzdCwgSW5jLiAtIGZvciBh
# dXRob3JpemVkIHVzZSBvbmx5MTIwMAYDVQQDEylFbnRydXN0IFJvb3QgQ2VydGlm
# aWNhdGlvbiBBdXRob3JpdHkgLSBHMjAeFw0xNTA2MTAxMzQyNDlaFw0zMDExMTAx
# NDEyNDlaMIHIMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjEo
# MCYGA1UECxMfU2VlIHd3dy5lbnRydXN0Lm5ldC9sZWdhbC10ZXJtczE5MDcGA1UE
# CxMwKGMpIDIwMTUgRW50cnVzdCwgSW5jLiAtIGZvciBhdXRob3JpemVkIHVzZSBv
# bmx5MTwwOgYDVQQDEzNFbnRydXN0IEV4dGVuZGVkIFZhbGlkYXRpb24gQ29kZSBT
# aWduaW5nIENBIC0gRVZDUzEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDCvTcBUALFjaAu6GYnHZUIy25XB1LW0LrF3euJF8ImXC9xK37LNqRREEd4nmoZ
# NOgdYyPieuOhKrZqae5SsMpnwyjY83cwTpCAZJm/6m9nZRIi25xuAw2oUGH4WMSd
# fTrwgSX/8yoS4WvlTZVFysFX9yAtx4EUgbqYLygPSULr/C9rwM298YzqPvw/sXx9
# d7y4YmgyA7Bj8irPXErEQl+bgis4/tlGm0xfY7c0rFT7mcQBI/vJCZTjO59K4oow
# 56ScK63Cb212E4I7GHJpewOYBUpLm9St3OjXvWjuY96yz/c841SAD/sjrLUyXE5A
# PfhMspUyThqkyEbw3weHuJrvAgMBAAGjggEhMIIBHTAOBgNVHQ8BAf8EBAMCAQYw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwEgYDVR0TAQH/BAgwBgEB/wIBADAzBggrBgEF
# BQcBAQQnMCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3QubmV0MDAG
# A1UdHwQpMCcwJaAjoCGGH2h0dHA6Ly9jcmwuZW50cnVzdC5uZXQvZzJjYS5jcmww
# OwYDVR0gBDQwMjAwBgRVHSAAMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cuZW50
# cnVzdC5uZXQvcnBhMB0GA1UdDgQWBBQqCm8yLCkgIXZqsayMPK+Tjg5rojAfBgNV
# HSMEGDAWgBRqciZ60B7vfec7aVHUbI2fkBJmqzANBgkqhkiG9w0BAQsFAAOCAQEA
# KdkNr2dFXRsJb63MiBD1qi4mF+2Ih6zA+B1TuRAPZTIzazJPXdYdD3h8CVS1WhKH
# X6Q2SwdH0Gdsoipgwl0I3SNgPXkqoBX09XVdIVfA8nFDB6k+YMUZA/l8ub6ARctY
# xthqVO7Or7jUjpA5E3EEXbj8h9UMLM5w7wUcdBAteXZKeFU7SOPId1AdefnWSD/n
# bqvfvZLnJyfAWLO+Q5VvpPzZNgBa+8mM9DieRiaIvILQX30SeuWbL9TEU+XBKdyQ
# +P/h8jqHo+/edtNuajulxlIwHmOrwAlA8cnC8sw41jqy2hVo/IyXdSpYCSziidmE
# CU2X7RYuZTGuuPUtJcF5dDCCBY0wggR1oAMCAQICEHBxdTqSJ2A9AAAAAFVlpdkw
# DQYJKoZIhvcNAQELBQAwgcgxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1FbnRydXN0
# LCBJbmMuMSgwJgYDVQQLEx9TZWUgd3d3LmVudHJ1c3QubmV0L2xlZ2FsLXRlcm1z
# MTkwNwYDVQQLEzAoYykgMjAxNSBFbnRydXN0LCBJbmMuIC0gZm9yIGF1dGhvcml6
# ZWQgdXNlIG9ubHkxPDA6BgNVBAMTM0VudHJ1c3QgRXh0ZW5kZWQgVmFsaWRhdGlv
# biBDb2RlIFNpZ25pbmcgQ0EgLSBFVkNTMTAeFw0xOTEwMTYxOTE5MzhaFw0yMDEy
# MTIxOTQ5MjhaMIHYMQswCQYDVQQGEwJVUzEOMAwGA1UECBMFVGV4YXMxEzARBgNV
# BAcTClJvdW5kIFJvY2sxEzARBgsrBgEEAYI3PAIBAxMCVVMxGTAXBgsrBgEEAYI3
# PAIBAhMIRGVsYXdhcmUxETAPBgNVBAoTCERlbGwgSW5jMR0wGwYDVQQPExRQcml2
# YXRlIE9yZ2FuaXphdGlvbjEdMBsGA1UECxMUQ2xpZW50IFByb2R1Y3QgR3JvdXAx
# EDAOBgNVBAUTBzIxNDE1NDExETAPBgNVBAMTCERlbGwgSW5jMIIBIjANBgkqhkiG
# 9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxzH4/Uk7SrrIRybkbZYYU8fiPfIL3ekXg2cQ
# mVhptYD7QNfVbte+R+e8owQqoiBlgkauoRIU3V2aK7FJCgXok0Fl09xMFNmB23Mc
# Hlrsjm6NdjtiocVpd+P8yMjuJt9R5SUrRWr3HWlLyDnK0YiURCTpHOaN6/bb55wT
# eiJItYOgwDblltVN38b1iNN+rrae81ZaA06ofx998NF4Ofoq5NGc3pC3Wk0wCksS
# QpA+koBuuoRrvJkxKDQfGoBmJxexQhziRnDll6DxyQ550fsxmsVcY4LTvgt7pMUF
# xQ4JXAL9QTWLihzgUaW/WIesCmS8dezRP2X5uCL5t9d3w6ERKwIDAQABo4IBXzCC
# AVswDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMGoGCCsGAQUF
# BwEBBF4wXDAjBggrBgEFBQcwAYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwNQYI
# KwYBBQUHMAKGKWh0dHA6Ly9haWEuZW50cnVzdC5uZXQvZXZjczEtY2hhaW4yNTYu
# Y2VyMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvZXZj
# czEuY3JsMEoGA1UdIARDMEEwNgYKYIZIAYb6bAoBAjAoMCYGCCsGAQUFBwIBFhpo
# dHRwOi8vd3d3LmVudHJ1c3QubmV0L3JwYTAHBgVngQwBAzAfBgNVHSMEGDAWgBQq
# Cm8yLCkgIXZqsayMPK+Tjg5rojAdBgNVHQ4EFgQU7+AIvIOh/qMSwsaU6b8HBj+6
# NVYwCQYDVR0TBAIwADANBgkqhkiG9w0BAQsFAAOCAQEAPNM/JRouTEuEpxSM/Ihu
# YSFwcj3NmlA2T/9VDre41akRDaAmWEHK19EWN3wb4MPFK1I0f/NjDL+jiX2UZNZj
# A69NCmw7FCaKBPmuVZihPvb4BF1jVuDNQj5GWj5nW3wgIPzduSe6aLzIBO4xsKKb
# Cw0lOtRLzF/UEdqbMx11ns4BMAZeADsT5oKBTjQdJ26njRKZmJA4uc8F649mFqkA
# x0x6PM0alM/+O4xCJ3wXay63Jurr7CiTFXytE+K9jzfPZ6iI2elmx1Eoj4QkcCwX
# ho9KDdn4psSO6kznVjezKdUZU7yEbs4273R0Vr7bWgEqMOfMS7oUpaxJ7OKheVEE
# rjGCEMcwghDDAgEBMIHdMIHIMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVz
# dCwgSW5jLjEoMCYGA1UECxMfU2VlIHd3dy5lbnRydXN0Lm5ldC9sZWdhbC10ZXJt
# czE5MDcGA1UECxMwKGMpIDIwMTUgRW50cnVzdCwgSW5jLiAtIGZvciBhdXRob3Jp
# emVkIHVzZSBvbmx5MTwwOgYDVQQDEzNFbnRydXN0IEV4dGVuZGVkIFZhbGlkYXRp
# b24gQ29kZSBTaWduaW5nIENBIC0gRVZDUzECEHBxdTqSJ2A9AAAAAFVlpdkwDQYJ
# YIZIAWUDBAIBBQCgfDAQBgorBgEEAYI3AgEMMQIwADAZBgkqhkiG9w0BCQMxDAYK
# KwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG
# 9w0BCQQxIgQgWn4fflILAI+v/S4ULV2TAeLRUPAl5YEPYe76IkLwQU8wDQYJKoZI
# hvcNAQEBBQAEggEApabDXuLwIUzwbrIq8tKuAFzJ0HuSmVlBQZqZ5CJaxY32MvTr
# VKDc1wkRxU3pELPfKWR/AFNu3OZ4mVWIygJNa2H0hoKdxZisgq9NTV6SeIIxtRf5
# c6CUPJvoNwcTP7XngRTQ8OATDyM2XDw7KjcQGfjqIecKp8NwmfqmwfgIRtpIVWAf
# VJ4nSQnsdhufFtP+geUmZrDXasc7Fx7JLXeLn64O3Pdagev9qX0+omsOeyzXXzC5
# wu2ysEp6b4Mv0eu0U4KBTzC60cuR514leh8dEpM5IR0fMvG87mO2xED8NMzbbdWf
# ucu0ylRqZvwRwTnlvEsfrDFM9aDyASFmMm/E36GCDjwwgg44BgorBgEEAYI3AwMB
# MYIOKDCCDiQGCSqGSIb3DQEHAqCCDhUwgg4RAgEDMQ0wCwYJYIZIAWUDBAIBMIIB
# DgYLKoZIhvcNAQkQAQSggf4EgfswgfgCAQEGC2CGSAGG+EUBBxcDMDEwDQYJYIZI
# AWUDBAIBBQAEIKfMPkq+HhmM7/JGwqVAM1X45wYBIlqWByj/BqkSqkGmAhQn1eR0
# u/Y+NFnDkzQMNhvKUCtCLxgPMjAyMDAzMjAxMDA3NThaMAMCAR6ggYakgYMwgYAx
# CzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0G
# A1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazExMC8GA1UEAxMoU3ltYW50ZWMg
# U0hBMjU2IFRpbWVTdGFtcGluZyBTaWduZXIgLSBHM6CCCoswggU4MIIEIKADAgEC
# AhB7BbHUSWhRRPfJidKcGZ0SMA0GCSqGSIb3DQEBCwUAMIG9MQswCQYDVQQGEwJV
# UzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRy
# dXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAyMDA4IFZlcmlTaWduLCBJbmMuIC0g
# Rm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxODA2BgNVBAMTL1ZlcmlTaWduIFVuaXZl
# cnNhbCBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE2MDExMjAwMDAw
# MFoXDTMxMDExMTIzNTk1OVowdzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFu
# dGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3Jr
# MSgwJgYDVQQDEx9TeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIENBMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1mdWVVPnYxyXRqBoutV87ABrTxx
# rDKPBWuGmicAMpdqTclkFEspu8LZKbku7GOz4c8/C1aQ+GIbfuumB+Lef15tQDjU
# kQbnQXx5HMvLrRu/2JWR8/DubPitljkuf8EnuHg5xYSl7e2vh47Ojcdt6tKYtTof
# Hjmdw/SaqPSE4cTRfHHGBim0P+SDDSbDewg+TfkKtzNJ/8o71PWym0vhiJka9cDp
# MxTW38eA25Hu/rySV3J39M2ozP4J9ZM3vpWIasXc9LFL1M7oCZFftYR5NYp4rBky
# jyPBMkEbWQ6pPrHM+dYr77fY5NUdbRE6kvaTyZzjSO67Uw7UNpeGeMWhNwIDAQAB
# o4IBdzCCAXMwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwZgYD
# VR0gBF8wXTBbBgtghkgBhvhFAQcXAzBMMCMGCCsGAQUFBwIBFhdodHRwczovL2Qu
# c3ltY2IuY29tL2NwczAlBggrBgEFBQcCAjAZGhdodHRwczovL2Quc3ltY2IuY29t
# L3JwYTAuBggrBgEFBQcBAQQiMCAwHgYIKwYBBQUHMAGGEmh0dHA6Ly9zLnN5bWNk
# LmNvbTA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vcy5zeW1jYi5jb20vdW5pdmVy
# c2FsLXJvb3QuY3JsMBMGA1UdJQQMMAoGCCsGAQUFBwMIMCgGA1UdEQQhMB+kHTAb
# MRkwFwYDVQQDExBUaW1lU3RhbXAtMjA0OC0zMB0GA1UdDgQWBBSvY9bKo06FcuCn
# vEHzKaI4f4B1YjAfBgNVHSMEGDAWgBS2d/ppSEefUxLVwuoHMnYH0ZcHGTANBgkq
# hkiG9w0BAQsFAAOCAQEAdeqwLdU0GVwyRf4O4dRPpnjBb9fq3dxP86HIgYj3p48V
# 5kApreZd9KLZVmSEcTAq3R5hF2YgVgaYGY1dcfL4l7wJ/RyRR8ni6I0D+8yQL9YK
# bE4z7Na0k8hMkGNIOUAhxN3WbomYPLWYl+ipBrcJyY9TV0GQL+EeTU7cyhB4bEJu
# 8LbF+GFcUvVO9muN90p6vvPN/QPX2fYDqA/jU/cKdezGdS6qZoUEmbf4Blfhxg72
# 6K/a7JsYH6q54zoAv86KlMsB257HOLsPUqvR45QDYApNoP4nbRQy/D+XQOG/mYnb
# 5DkUvdrk08PqK1qzlVhVBH3HmuwjA42FKtL/rqlhgTCCBUswggQzoAMCAQICEHvU
# 5a+6zAc/oQEjBCJBTRIwDQYJKoZIhvcNAQELBQAwdzELMAkGA1UEBhMCVVMxHTAb
# BgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBU
# cnVzdCBOZXR3b3JrMSgwJgYDVQQDEx9TeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1w
# aW5nIENBMB4XDTE3MTIyMzAwMDAwMFoXDTI5MDMyMjIzNTk1OVowgYAxCzAJBgNV
# BAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMW
# U3ltYW50ZWMgVHJ1c3QgTmV0d29yazExMC8GA1UEAxMoU3ltYW50ZWMgU0hBMjU2
# IFRpbWVTdGFtcGluZyBTaWduZXIgLSBHMzCCASIwDQYJKoZIhvcNAQEBBQADggEP
# ADCCAQoCggEBAK8Oiqr43L9pe1QXcUcJvY08gfh0FXdnkJz93k4Cnkt29uU2PmXV
# JCBtMPndHYPpPydKM05tForkjUCNIqq+pwsb0ge2PLUaJCj4G3JRPcgJiCYIOvn6
# QyN1R3AMs19bjwgdckhXZU2vAjxA9/TdMjiTP+UspvNZI8uA3hNN+RDJqgoYbFVh
# V9HxAizEtavybCPSnw0PGWythWJp/U6FwYpSMatb2Ml0UuNXbCK/VX9vygarP0q3
# InZl7Ow28paVgSYs/buYqgE4068lQJsJU/ApV4VYXuqFSEEhh+XetNMmsntAU1h5
# jlIxBk2UA0XEzjwD7LcA8joixbRv5e+wipsCAwEAAaOCAccwggHDMAwGA1UdEwEB
# /wQCMAAwZgYDVR0gBF8wXTBbBgtghkgBhvhFAQcXAzBMMCMGCCsGAQUFBwIBFhdo
# dHRwczovL2Quc3ltY2IuY29tL2NwczAlBggrBgEFBQcCAjAZGhdodHRwczovL2Qu
# c3ltY2IuY29tL3JwYTBABgNVHR8EOTA3MDWgM6Axhi9odHRwOi8vdHMtY3JsLndz
# LnN5bWFudGVjLmNvbS9zaGEyNTYtdHNzLWNhLmNybDAWBgNVHSUBAf8EDDAKBggr
# BgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwdwYIKwYBBQUHAQEEazBpMCoGCCsGAQUF
# BzABhh5odHRwOi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wOwYIKwYBBQUHMAKG
# L2h0dHA6Ly90cy1haWEud3Muc3ltYW50ZWMuY29tL3NoYTI1Ni10c3MtY2EuY2Vy
# MCgGA1UdEQQhMB+kHTAbMRkwFwYDVQQDExBUaW1lU3RhbXAtMjA0OC02MB0GA1Ud
# DgQWBBSlEwGpn4XMG24WHl87Map5NgB7HTAfBgNVHSMEGDAWgBSvY9bKo06FcuCn
# vEHzKaI4f4B1YjANBgkqhkiG9w0BAQsFAAOCAQEARp6v8LiiX6KZSM+oJ0shzbK5
# pnJwYy/jVSl7OUZO535lBliLvFeKkg0I2BC6NiT6Cnv7O9Niv0qUFeaC24pUbf8o
# /mfPcT/mMwnZolkQ9B5K/mXM3tRr41IpdQBKK6XMy5voqU33tBdZkkHDtz+G5vbA
# f0Q8RlwXWuOkO9VpJtUhfeGAZ35irLdOLhWa5Zwjr1sR6nGpQfkNeTipoQ3PtLHa
# Ppp6xyLFdM3fRwmGxPyRJbIblumFCOjd6nRgbmClVnoNyERY3Ob5SBSe5b/eAL13
# sZgUchQk38cRLB8AP8NLFMZnHMweBqOQX1xUiz7jM1uCD8W3hgJOcZ/pZkU/djGC
# AlowggJWAgEBMIGLMHcxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBD
# b3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEoMCYG
# A1UEAxMfU3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBDQQIQe9Tlr7rMBz+h
# ASMEIkFNEjALBglghkgBZQMEAgGggaQwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJ
# EAEEMBwGCSqGSIb3DQEJBTEPFw0yMDAzMjAxMDA3NThaMC8GCSqGSIb3DQEJBDEi
# BCAr8kCyEjVpK6dW4650rSZtpbU+1qnKhd3EXJ0CdgQf/jA3BgsqhkiG9w0BCRAC
# LzEoMCYwJDAiBCDEdM52AH0COU4NpeTefBTGgPniggE8/vZT7123H99h+DALBgkq
# hkiG9w0BAQEEggEAjy7jPcvvMBs/9fVQY5Vx5/er9ovvuHzGhMx6I1DIy9okSflC
# WBmt0+dK/6+iG7lveLOSKMkve3qeubUf39Qv39oURrac7s6ioCtW8jIKGquW5SNp
# 1HnyiXXwUiEWGsmFfQCe0Sx5Srhwjhdhw8MG/th7KWSZKlf4bqDgZnTNA6nN/oG/
# fZSNoFFRe1QhU6XkfNGgAHX6BJINgxojxnwvBOgF62iHvg/XKyzS6rOla8eKnTiS
# 1Lpa+Cm93+jjdSEnf8Bor50GbJxuFew84S/Br9RhofoPVw/YQJgwH4sBdSEhhEKc
# ZA/NeHyzS1QaD62VF5J5eVc8ra+Lc29hcHxb8g==
# SIG # End signature block
