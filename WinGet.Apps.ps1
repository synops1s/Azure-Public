##### Install WinGet Apps:

function Install-WinGetApps {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Object[]]$Apps = @(

            [PSCustomObject]@{ Id = "7zip.7zip"; Source = "winget"; Scope = "machine" }
            [PSCustomObject]@{ Id = "Git.Git"; Source = "winget"; Scope = "machine" }
            [PSCustomObject]@{ Id = "Microsoft.Azure.AZCopy.10"; Source = "winget"; Scope = "machine" }
            [PSCustomObject]@{ Id = "Microsoft.Azure.StorageExplorer"; Source = "winget"; Scope = "machine" }
            [PSCustomObject]@{ Id = "Microsoft.Bicep"; Source = "winget"; Scope = "user" }
            [PSCustomObject]@{ Id = "Microsoft.PowerShell"; Source = "winget"; Scope = "machine" }
            [PSCustomObject]@{ Id = "Microsoft.SQLServerManagementStudio"; Version = "19.1"; Source = "winget"; Scope = "machine" }
            [PSCustomObject]@{ Id = "Microsoft.VisualStudioCode"; Source = "winget"; Scope = "machine" }
            [PSCustomObject]@{ Id = "Microsoft.WindowsTerminal"; Source = "winget"; Scope = "user" }
            [PSCustomObject]@{ Id = "Microsoft.Sysinternals.ProcessExplorer"; Source = "winget"; Scope = "machine" }

            # [PSCustomObject]@{ Id = "GitHub.GitHubDesktop"; Source = "winget"; Scope = "machine" }
            # [PSCustomObject]@{ Id = "WiresharkFoundation.Wireshark"; Source = "winget"; Scope = "machine" }
            # [PSCustomObject]@{ Id = "Hashicorp.Terraform"; Source = "winget"; Scope = "machine" }
            # [PSCustomObject]@{ Id = "Google.Chrome"; Source = "winget"; Scope = "machine" }
            # [PSCustomObject]@{ Id = "Microsoft.AzureVPNClient"; Source = "winget"; Scope = "machine" }
            # [PSCustomObject]@{ Id = "PuTTY.PuTTY"; Source = "winget"; Scope = "machine" }
            # [PSCustomObject]@{ Id = "Microsoft.AzureCLI"; Source = "winget"; Scope = "machine" }
        )
    )
 
    $Apps | ForEach-Object {

        $App = $_
    
        Write-Verbose -Message "Installing '$($App.Id)'"
        $ArgumentList = "install --silent --accept-package-agreements --accept-source-agreements --id=$($App.Id)"
    
        if($null -ne $App.Version) {
    
            Write-Verbose -Message "Version = '$($App.Version)'"
            $ArgumentList += " --version=$($App.Version) --exact"
        }
    
        if($null -ne $App.Source) {
    
            Write-Verbose -Message "Source = '$($App.Source)'"
            $ArgumentList += " --source=$($App.Source)"
        }

        if($null -ne $App.Scope) {
    
            Write-Verbose -Message "Scope = '$($App.Scope)'"
            $ArgumentList += " --scope=$($App.Scope)"
        }
    
        Write-Verbose -Message "ArgumentList = '$($ArgumentList)'"
        Start-Process -FilePath "winget" -ArgumentList $ArgumentList -Wait -NoNewWindow
    }
}

Install-WinGetApps -Verbose
