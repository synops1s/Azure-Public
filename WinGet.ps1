$WingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
$WingetMsixBundle = $WingetMsixBundleUri.Split("/")[-1]

Write-Information "Downloading winget to artifacts directory..."

Invoke-WebRequest -Uri $WingetMsixBundleUri -OutFile "./$WingetMsixBundle"
Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "Microsoft.VCLibs.x64.14.00.Desktop.appx"

Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage $latestWingetMsixBundle
