##### Install WinGet:

Add-Type -AssemblyName System.IO.Compression.FileSystem

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TempPath = [System.IO.Path]::GetTempPath()

$VCLibsUri = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
$VCLibsFileName = $VCLibsUri.Split("/")[-1]
$VCLibsFilePath = (Join-Path -Path $TempPath -ChildPath $VCLibsFileName)

$XamlUri = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.0"
$XamlFileName = "microsoft.ui.xaml.2.7"
$XamlNugetFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName).nupkg")
$XamlZipFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName).zip")
$XamlAppxFilePath = (Join-Path -Path $TempPath -ChildPath "$($XamlFileName).appx")

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
$XamlZip = [IO.Compression.ZipFile]::OpenRead($XamlZipFilePath)
$XamlZip.Entries | Where-Object { $_.FullName -like "*x64*.appx" } | ForEach-Object { [IO.Compression.ZipFileExtensions]::ExtractToFile($_, $XamlAppxFilePath) }
$XamlZip.Dispose()
Remove-Item -Path $XamlZipFilePath -Force -ErrorAction SilentlyContinue

Add-AppxProvisionedPackage -Online -PackagePath $MsixBundleFilePath -LicensePath $MsixBundleLicenseFilePath -DependencyPackagePath @($VCLibsFilePath, $XamlAppxFilePath)

Remove-Item -Path $MsixBundleFilePath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $MsixBundleLicenseFilePath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $VCLibsFilePath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $XamlAppxFilePath -Force -ErrorAction SilentlyContinue
