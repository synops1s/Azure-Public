[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TempPath = [System.IO.Path]::GetTempPath()

$MsixBundleUri = $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets.browser_download_url | Where-Object { $_.EndsWith(".msixbundle") }
$MsixBundleFileName = $MsixBundleUri.Split("/")[-1]
$MsixBundleFilePath = (Join-Path -Path $TempPath -ChildPath $MsixBundleFileName)

$MsixBundleLicenseUri = $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets.browser_download_url | Where-Object { $_.EndsWith(".xml") }
$MsixBundleLicenseFileName = $MsixBundleLicenseUri.Split("/")[-1]
$MsixBundleLicenseFilePath = (Join-Path -Path $TempPath -ChildPath $MsixBundleLicenseFileName)

Write-Information "Downloading Winget to artifacts directory..."
Invoke-WebRequest -Uri $MsixBundleUri -OutFile $MsixBundleFilePath

Write-Information "Downloading WinGet License to artifacts directory..."
Invoke-WebRequest -Uri $MsixBundleLicenseUri -OutFile $MsixBundleLicenseFilePath

Add-ProvisionedAppxPackage -PackagePath $MsixBundleFilePath -LicensePath $MsixBundleLicenseFilePath -Online

Remove-Item -Path $MsixBundleFilePath -ErrorAction SilentlyContinue
Remove-Item -Path $MsixBundleLicenseFilePath -ErrorAction SilentlyContinue
