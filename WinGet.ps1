[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TempPath = [System.IO.Path]::GetTempPath()

$XamlUri = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.0"
$XamlFileName = "microsoft.ui.xaml.2.7"
$XamlNugetFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName).nupkg")
$XamlZipFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName).zip")
$XamlAppxFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName)\tools\AppX\x64\Release\$($XamlFileName).appx")

$MsixBundleUri = $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets.browser_download_url | Where-Object { $_.EndsWith(".msixbundle") }
$MsixBundleFileName = $MsixBundleUri.Split("/")[-1]
$MsixBundleFilePath = (Join-Path -Path $TempPath -ChildPath $MsixBundleFileName)

$MsixBundleLicenseUri = $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets.browser_download_url | Where-Object { $_.EndsWith(".xml") }
$MsixBundleLicenseFileName = $MsixBundleLicenseUri.Split("/")[-1]
$MsixBundleLicenseFilePath = (Join-Path -Path $TempPath -ChildPath $MsixBundleLicenseFileName)

Invoke-WebRequest -Uri $XamlUri -OutFile $XamlNugetFilePath
Invoke-WebRequest -Uri $MsixBundleUri -OutFile $MsixBundleFilePath
Invoke-WebRequest -Uri $MsixBundleLicenseUri -OutFile $MsixBundleLicenseFilePath

Remove-Item -Path $XamlZipFilePath -Force -ErrorAction SilentlyContinue
Rename-Item -Path $XamlNugetFilePath -NewName $XamlZipFilePath
Expand-Archive $XamlZipFilePath -Force

Add-ProvisionedAppxPackage -PackagePath $XamlAppxFilePath -Online -SkipLicense
Add-ProvisionedAppxPackage -PackagePath $MsixBundleFilePath -LicensePath $MsixBundleLicenseFilePath -Online
