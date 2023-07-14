[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TempPath = [System.IO.Path]::GetTempPath()

# $ProviderAssemblyPath = (Join-Path -Path ( [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ProgramFiles)) -ChildPath "PackageManagement\ProviderAssemblies")
# $NugetProviderUri = "https://onegetcdn.azureedge.net/providers/Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll"
# $NugetProviderRepoFilePath = (Join-Path -Path $TempPath -ChildPath "Microsoft.PackageManagement.NuGetProvider.dll")
# Invoke-WebRequest -Uri $NugetProviderUri -OutFile $NugetProviderRepoFilePath
# Unblock-File -Path $NugetProviderRepoFilePath
# Move-Item -Path $NugetProviderRepoFilePath -Destination $ProviderAssemblyPath -Force

$VCLibsUri = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
$VCLibsFileName = $VCLibsUri.Split("/")[-1]
$VCLibsFilePath = (Join-Path -Path $TempPath -ChildPath $VCLibsFileName)

$XamlUri = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.0"
$XamlFileName = "microsoft.ui.xaml.2.7"
$XamlNugetFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName).nupkg")
$XamlZipFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName).zip")
$XamlAppxFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName)\tools\AppX\x64\Release\$($XamlFileName).appx")

$MsixBundleLicenseUri = $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets.browser_download_url | Where-Object { $_.EndsWith(".xml") }
$MsixBundleLicenseFileName = $MsixBundleLicenseUri.Split("/")[-1]
$MsixBundleLicenseFilePath = (Join-Path -Path $TempPath -ChildPath $MsixBundleLicenseFileName)

$MsixBundleUri = $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets.browser_download_url | Where-Object { $_.EndsWith(".msixbundle") }
$MsixBundleFileName = $MsixBundleUri.Split("/")[-1]
$MsixBundleFilePath = (Join-Path -Path $TempPath -ChildPath $MsixBundleFileName)

Invoke-WebRequest -Uri $MsixBundleLicenseUri -OutFile $MsixBundleLicenseFilePath
Invoke-WebRequest -Uri $VCLibsUri -OutFile $VCLibsFilePath
Invoke-WebRequest -Uri $XamlUri -OutFile $XamlNugetFilePath
Invoke-WebRequest -Uri $MsixBundleUri -OutFile $MsixBundleFilePath

Remove-Item -Path $XamlZipFilePath -Force -ErrorAction SilentlyContinue
Rename-Item -Path $XamlNugetFilePath -NewName $XamlZipFilePath
Expand-Archive $XamlZipFilePath -Force -DestinationPath (Join-Path -Path $TempPath -ChildPath $XamlFileName)

Add-AppxPackage -Path $VCLibsFilePath
Add-AppxPackage -Path $XamlAppxFilePath
Add-ProvisionedAppxPackage -PackagePath $MsixBundleFilePath -LicensePath $MsixBundleLicenseFilePath -Online
Add-AppxPackage -Path $MsixBundleFilePath

# winget install Microsoft.SQLServerManagementStudio
