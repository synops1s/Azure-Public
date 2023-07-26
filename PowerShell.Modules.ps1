##### PowerShell Modules:

function Install-PSModules {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Object[]]$Modules = @(

            [PSCustomObject]@{ Name = "Az"; Scope = "AllUsers" }
        )
    )
 
    $Modules | ForEach-Object {

        $Module = $_

        Write-Verbose -Message "Installing Module '$($Module.Name)'"

        $Parameters = @{

            Name = $Module.Name
            Scope = $Module.Scope
        }

        Write-Verbose -Message "Name = '$($Parameters.Name)'"
        Write-Verbose -Message "Scope = '$($Parameters.Scope)'"

        if($null -ne $Module.Version) {

            $Parameters.RequiredVersion = $Module.Version
            Write-Verbose -Message "RequiredVersion = '$($Parameters.RequiredVersion)'"
        }
        
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Install-Module @Parameters -Force -Verbose:$VerbosePreference
    }
}

Install-PSModules -Verbose
