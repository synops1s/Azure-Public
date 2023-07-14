[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TempPath = [System.IO.Path]::GetTempPath()

$MsixBundleUri = $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
$MsixBundleFileName = $MsixBundleUri.Split("/")[-1]
$MsixBundleFilePath = (Join-Path -Path $TempPath -ChildPath $MsixBundleFileName)

$VCLibsFileName = "Microsoft.VCLibs.x64.14.00.Desktop.appx"
$VCLibsUri = "https://aka.ms/$($VCLibsFileName)"
$VCLibsFilePath = (Join-Path -Path $TempPath -ChildPath $VCLibsFileName)

Write-Information "Downloading VC Libs to artifacts directory..."
Invoke-WebRequest -Uri $VCLibsUri -OutFile $VCLibsFilePath
Write-Information "Downloading WinGet to artifacts directory..."
Invoke-WebRequest -Uri $MsixBundleUri -OutFile $MsixBundleFilePath

Add-AppxPackage -Path $VCLibsFilePath
Add-AppxPackage -Path $MsixBundleFilePath

Remove-Item -Path $VCLibsFilePath -ErrorAction SilentlyContinue
Remove-Item -Path $MsixBundleFilePath -ErrorAction SilentlyContinue
