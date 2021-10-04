[CmdletBinding()]
param()

function Add-TestCapability {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        $ShellPath,

        [Parameter(Mandatory = $true)]
        [ref]$Value)

    $directory = [System.IO.Path]::Combine($ShellPath, 'Common7\IDE\CommonExtensions\Microsoft\TestWindow')
    if (!(Test-Container -LiteralPath $directory)) {
        return
    }

    [string]$file = [System.IO.Path]::Combine($directory, 'vstest.console.exe')
    if (!(Test-Leaf -LiteralPath $file)) {
        return
    }

    Write-Capability -Name $Name -Value $directory
    $Value.Value = $directory
}

# Define the key names.
$keyName10 = 'Software\Microsoft\VisualStudio\10.0'
$keyName11 = 'Software\Microsoft\VisualStudio\11.0'
$keyName12 = 'Software\Microsoft\VisualStudio\12.0'
$keyName14 = 'Software\Microsoft\VisualStudio\14.0'
$keyName15 = 'Software\Microsoft\VisualStudio\15.0'
$keyName16 = 'Software\Microsoft\VisualStudio\16.0'

# Add the capabilities.
$latestVS = $null
$latestIde = $null
$latestTest = $null
$null = Add-CapabilityFromRegistry -Name 'VisualStudio_10.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName10 -ValueName 'ShellFolder' -Value ([ref]$latestVS)
$null = Add-CapabilityFromRegistry -Name 'VisualStudio_IDE_10.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName10 -ValueName 'InstallDir' -Value ([ref]$latestIde)
$null = Add-CapabilityFromRegistry -Name 'VisualStudio_11.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName11 -ValueName 'ShellFolder' -Value ([ref]$latestVS)
$null = Add-CapabilityFromRegistry -Name 'VisualStudio_IDE_11.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName11 -ValueName 'InstallDir' -Value ([ref]$latestIde)
if ((Add-CapabilityFromRegistry -Name 'VisualStudio_12.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName12 -ValueName 'ShellFolder' -Value ([ref]$latestVS))) {
    $null = Add-CapabilityFromRegistry -Name 'VisualStudio_IDE_12.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName12 -ValueName 'InstallDir' -Value ([ref]$latestIde)
    Add-TestCapability -Name 'VSTest_12.0' -ShellPath $latestVS -Value ([ref]$latestTest)
}

if ((Add-CapabilityFromRegistry -Name 'VisualStudio_14.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName14 -ValueName 'ShellFolder' -Value ([ref]$latestVS))) {
    $null = Add-CapabilityFromRegistry -Name 'VisualStudio_IDE_14.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName14 -ValueName 'InstallDir' -Value ([ref]$latestIde)
    Add-TestCapability -Name 'VSTest_14.0' -ShellPath $latestVS -Value ([ref]$latestTest)
}

$vs15 = Get-VisualStudio -MajorVersion 15
if ($vs15 -and $vs15.installationPath) {
    # Add VisualStudio_15.0.
    # End with "\" for consistency with old ShellFolder values.
    $shellFolder15 = $vs15.installationPath.TrimEnd('\'[0]) + "\"
    Write-Capability -Name 'VisualStudio_15.0' -Value $shellFolder15
    $latestVS = $shellFolder15

    # Add VisualStudio_IDE_15.0.
    # End with "\" for consistency with old InstallDir values.
    $installDir15 = ([System.IO.Path]::Combine($shellFolder15, 'Common7', 'IDE')) + '\'
    if ((Test-Container -LiteralPath $installDir15)) {
        Write-Capability -Name 'VisualStudio_IDE_15.0' -Value $installDir15
        $latestIde = $installDir15
    }

    # Add VSTest_15.0.
    $testWindowDir15 = [System.IO.Path]::Combine($installDir15, 'CommonExtensions\Microsoft\TestWindow')
    $vstestConsole15 = [System.IO.Path]::Combine($testWindowDir15, 'vstest.console.exe')
    if ((Test-Leaf -LiteralPath $vstestConsole15)) {
        Write-Capability -Name 'VSTest_15.0' -Value $testWindowDir15
        $latestTest = $testWindowDir15
    }
} else {
    if ((Add-CapabilityFromRegistry -Name 'VisualStudio_15.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName15 -ValueName 'ShellFolder' -Value ([ref]$latestVS))) {
        $null = Add-CapabilityFromRegistry -Name 'VisualStudio_IDE_15.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName15 -ValueName 'InstallDir' -Value ([ref]$latestIde)
        Add-TestCapability -Name 'VSTest_15.0' -ShellPath $latestVS -Value ([ref]$latestTest)
    }
}

$vs16 = Get-VisualStudio -MajorVersion 16
if ($vs16 -and $vs16.installationPath) {
    # Add VisualStudio_16.0.
    # End with "\" for consistency with old ShellFolder values.
    $shellFolder16 = $vs16.installationPath.TrimEnd('\'[0]) + "\"
    Write-Capability -Name 'VisualStudio_16.0' -Value $shellFolder16
    $latestVS = $shellFolder16

    # Add VisualStudio_IDE_16.0.
    # End with "\" for consistency with old InstallDir values.
    $installDir16 = ([System.IO.Path]::Combine($shellFolder16, 'Common7', 'IDE')) + '\'
    if ((Test-Container -LiteralPath $installDir16)) {
        Write-Capability -Name 'VisualStudio_IDE_16.0' -Value $installDir16
        $latestIde = $installDir16
    }

    # Add VSTest_16.0.
    $testWindowDir16 = [System.IO.Path]::Combine($installDir16, 'CommonExtensions\Microsoft\TestWindow')
    $vstestConsole16 = [System.IO.Path]::Combine($testWindowDir16, 'vstest.console.exe')
    if ((Test-Leaf -LiteralPath $vstestConsole16)) {
        Write-Capability -Name 'VSTest_16.0' -Value $testWindowDir16
        $latestTest = $testWindowDir16
    }
} else {
    if ((Add-CapabilityFromRegistry -Name 'VisualStudio_16.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName16 -ValueName 'ShellFolder' -Value ([ref]$latestVS))) {
        $null = Add-CapabilityFromRegistry -Name 'VisualStudio_IDE_16.0' -Hive 'LocalMachine' -View 'Registry32' -KeyName $keyName16 -ValueName 'InstallDir' -Value ([ref]$latestIde)
        Add-TestCapability -Name 'VSTest_16.0' -ShellPath $latestVS -Value ([ref]$latestTest)
    }
}

if ($latestVS) {
    Write-Capability -Name 'VisualStudio' -Value $latestVS
}

if ($latestIde) {
    Write-Capability -Name 'VisualStudio_IDE' -Value $latestIde
}

if ($latestTest) {
    Write-Capability -Name 'VSTest' -Value $latestTest
}

# SIG # Begin signature block
# MIIjgwYJKoZIhvcNAQcCoIIjdDCCI3ACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA/cDr0Z2ZRUTOH
# +IPopWymnQVZJF3Nnq8x7rQAZHiGP6CCDYEwggX/MIID56ADAgECAhMzAAAB32vw
# LpKnSrTQAAAAAAHfMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ1WhcNMjExMjAyMjEzMTQ1WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC2uxlZEACjqfHkuFyoCwfL25ofI9DZWKt4wEj3JBQ48GPt1UsDv834CcoUUPMn
# s/6CtPoaQ4Thy/kbOOg/zJAnrJeiMQqRe2Lsdb/NSI2gXXX9lad1/yPUDOXo4GNw
# PjXq1JZi+HZV91bUr6ZjzePj1g+bepsqd/HC1XScj0fT3aAxLRykJSzExEBmU9eS
# yuOwUuq+CriudQtWGMdJU650v/KmzfM46Y6lo/MCnnpvz3zEL7PMdUdwqj/nYhGG
# 3UVILxX7tAdMbz7LN+6WOIpT1A41rwaoOVnv+8Ua94HwhjZmu1S73yeV7RZZNxoh
# EegJi9YYssXa7UZUUkCCA+KnAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUOPbML8IdkNGtCfMmVPtvI6VZ8+Mw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDYzMDA5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAnnqH
# tDyYUFaVAkvAK0eqq6nhoL95SZQu3RnpZ7tdQ89QR3++7A+4hrr7V4xxmkB5BObS
# 0YK+MALE02atjwWgPdpYQ68WdLGroJZHkbZdgERG+7tETFl3aKF4KpoSaGOskZXp
# TPnCaMo2PXoAMVMGpsQEQswimZq3IQ3nRQfBlJ0PoMMcN/+Pks8ZTL1BoPYsJpok
# t6cql59q6CypZYIwgyJ892HpttybHKg1ZtQLUlSXccRMlugPgEcNZJagPEgPYni4
# b11snjRAgf0dyQ0zI9aLXqTxWUU5pCIFiPT0b2wsxzRqCtyGqpkGM8P9GazO8eao
# mVItCYBcJSByBx/pS0cSYwBBHAZxJODUqxSXoSGDvmTfqUJXntnWkL4okok1FiCD
# Z4jpyXOQunb6egIXvkgQ7jb2uO26Ow0m8RwleDvhOMrnHsupiOPbozKroSa6paFt
# VSh89abUSooR8QdZciemmoFhcWkEwFg4spzvYNP4nIs193261WyTaRMZoceGun7G
# CT2Rl653uUj+F+g94c63AhzSq4khdL4HlFIP2ePv29smfUnHtGq6yYFDLnT0q/Y+
# Di3jwloF8EWkkHRtSuXlFUbTmwr/lDDgbpZiKhLS7CBTDj32I0L5i532+uHczw82
# oZDmYmYmIUSMbZOgS65h797rj5JJ6OkeEUJoAVwwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVWDCCFVQCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAd9r8C6Sp0q00AAAAAAB3zAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgiNSBbzgP
# mXJFClV/0G2USLWJdzc2uEGbnSpC7w66uScwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQAvyHZpHf3pwpI9r7h5D5SvD06GqC164hsSChThdxNU
# hf4N5CMU5563CTOYLzZrd/z84t/X0iDFBKsxExdrnjFA+U96iFj1gXovF/m0emXv
# 2IDdMXWXWkO1An6WHLRhkLckXhmGnPIto2X+8XQ/b3/EiICFZXgdSkcsnCjFFkrQ
# 5ahQ2o3cTa3JZw8PoVrZdvjENLpbYrqvG5qM2vNhJAdoePsE/l1LYsAk0IZh0bzn
# P6clIalGaR3YOB51jF/eKI8P5ggYDFN2BamOdXugjTAPOq0M4zwazDg6FW0oJWz8
# sG8g3fo1OL3aWs/d+7nt/TJWczug9+EFQ1LdaXhVve0PoYIS4jCCEt4GCisGAQQB
# gjcDAwExghLOMIISygYJKoZIhvcNAQcCoIISuzCCErcCAQMxDzANBglghkgBZQME
# AgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASCATwwggE4AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIIMQudsrMdTYR5ZVgt212Z1Tc1WNlxlUKMl+iUg+
# 8hvcAgZg0RSMrGMYEzIwMjEwNzAxMTQzMTQ2LjU0OFowBIACAfSggdCkgc0wgcox
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1p
# Y3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1Mg
# RVNOOjhBODItRTM0Ri05RERBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
# cCBTZXJ2aWNloIIOOTCCBPEwggPZoAMCAQICEzMAAAFLT7KmSNXkwlEAAAAAAUsw
# DQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcN
# MjAxMTEyMTgyNTU5WhcNMjIwMjExMTgyNTU5WjCByjELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2Eg
# T3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046OEE4Mi1FMzRGLTlE
# REExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQChNnpQx3YuJr/ivobPoLtpQ9egUFl8
# THdWZ6SAKIJdtP3L24D3/d63ommmjZjCyrQm+j/1tHDAwjQGuOwYvn79ecPCQfAB
# 91JnEp/wP4BMF2SXyMf8k9R84RthIdfGHPXTWqzpCCfNWolVEcUVm8Ad/r1LrikR
# O+4KKo6slDQJKsgKApfBU/9J7Rudvhw1rEQw0Nk1BRGWjrIp7/uWoUIfR4rcl6U1
# utOiYIonC87PPpAJQXGRsDdKnVFF4NpWvMiyeuksn5t/Otwz82sGlne/HNQpmMzi
# gR8cZ8eXEDJJNIZxov9WAHHj28gUE29D8ivAT706ihxvTv50ZY8W51uxAgMBAAGj
# ggEbMIIBFzAdBgNVHQ4EFgQUUqpqftASlue6K3LePlTTn01K68YwHwYDVR0jBBgw
# FoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDov
# L2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljVGltU3RhUENB
# XzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0
# cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNUaW1TdGFQQ0FfMjAx
# MC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDCDAN
# BgkqhkiG9w0BAQsFAAOCAQEAFtq51Zc/O1AfJK4tEB2Nr8bGEVD5qQ8l8gXIQMrM
# ZYtddHH+cGiqgF/4GmvmPfl5FAYh+gf/8Yd3q4/iD2+K4LtJbs/3v6mpyBl1mQ4v
# usK65dAypWmiT1W3FiXjsmCIkjSDDsKLFBYH5yGFnNFOEMgL+O7u4osH42f80nc2
# WdnZV6+OvW035XPV6ZttUBfFWHdIbUkdOG1O2n4yJm10OfacItZ08fzgMMqE+f/S
# TgVWNCHbR2EYqTWayrGP69jMwtVD9BGGTWti1XjpvE6yKdO8H9nuRi3L+C6jYntf
# aEmBTbnTFEV+kRx1CNcpSb9os86CAUehZU1aRzQ6CQ/pjzCCBnEwggRZoAMCAQIC
# CmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRp
# ZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIxMzY1NVoXDTI1MDcwMTIx
# NDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX9fp/aZRrdFQQ1aUKAIKF
# ++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkTjnxhMFmxMEQP8WCIhFRD
# DNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhHhjKEHnRhZ5FfgVSx
# z5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGKr0tkiVBisV39dx898Fd1
# rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox8NpOBpG2iAg16Hgc
# sOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEFTyJNAgMBAAGjggHmMIIB
# 4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIoxkPNDe3xGG8UzaFqF
# bVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1Ud
# EwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQwVgYD
# VR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwv
# cHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEB
# BE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9j
# ZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwgaAGA1UdIAEB/wSBlTCB
# kjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRtMEAGCCsGAQUFBwICMDQe
# MiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEAdABlAG0AZQBuAHQA
# LiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/gXEDPZ2joSFvs+umzPUx
# vs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgrUYJEEvu5U4zM9GAS
# inbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9Wj8c8pl5SpFSAK84Dxf1
# L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFwnzJKJ/1Vry/+tuWO
# M7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOdeyFtw5yjojz6f32WapB4
# pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1JeVk7Pf0v35jWSUPei45
# V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4TtxCd9ddJgiCGHasFAeb73x
# 4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5u+zGy9iCtHLNHfS4hQEe
# gPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3yKxO2ii4sanblrKn
# QqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Zta7cRDyXUHHXodLFVeNp
# 3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wknHNWzfjUeCLraNtvT
# X4/edIhJEqGCAsswggI0AgEBMIH4oYHQpIHNMIHKMQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBP
# cGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo4QTgyLUUzNEYtOURE
# QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcG
# BSsOAwIaAxUAkToz97fseHxNOUSQ5O/bBVSF+e6ggYMwgYCkfjB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAOSIGRAwIhgPMjAy
# MTA3MDExODM2MDBaGA8yMDIxMDcwMjE4MzYwMFowdDA6BgorBgEEAYRZCgQBMSww
# KjAKAgUA5IgZEAIBADAHAgEAAgIjJzAHAgEAAgIRWDAKAgUA5IlqkAIBADA2Bgor
# BgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAID
# AYagMA0GCSqGSIb3DQEBBQUAA4GBADPTufXH2B4Abf1OICh1ZSwQQk5vUUVh2FPp
# Uqk3LTwUchgH3ueTD6Pkf9oKG92CafIbYDOGhDbFgurPhCquCbq0fl6zDXiayoi3
# ClpYD8A3A+galgQ87FV43KjfBsMVe4fpYxfgdI3nZXq8Bduwod4GzBmZloGCjNKl
# AenLf3caMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAFLT7KmSNXkwlEAAAAAAUswDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqG
# SIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgAbaPV0Xt3tr1
# KBeuYB+u9hddkrP+78ti0NFg8FSfRS8wgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHk
# MIG9BCBr9u6EInnsZYEts/Fj/rIFv0YZW1ynhXKOP2hVPUU5IzCBmDCBgKR+MHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAABS0+ypkjV5MJRAAAAAAFL
# MCIEIFkomIPq6agBdlppTtdaEkO8OPSe5dmemXxI33fj9H/WMA0GCSqGSIb3DQEB
# CwUABIIBAJJLte/FT0Oyh/uKyAH7gtIp9SiGax5FS9t/zJS7EP6OtKpo+rMW6Tkq
# eLMWvOZmAlLnlFuZtJyD3M45CL9HcRO7BzCtS+Ecc9N3S4mc7LH9Lqxp270AEXMa
# i33DyidAKUtU4IoqCsjL5l7FCeuO7CVzfmVaO/LKhWUiEKP67hQzVvlSyYQV7XBr
# kn9v+/232uei4aGJrTi+z5BQrzo8K9jn5gezG5M/4nR7dXci5J8aC+UVJ4Rji34G
# AKtXvOnXwQFJwUdHTuCMIkXlz0gojcvLKk9blYr+wAr3zbZxuNhx6HNESILLb/U1
# blnlazuwXE5i/Ty4Kn77JcZokyQM418=
# SIG # End signature block
