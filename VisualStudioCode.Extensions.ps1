##### Visual Studio Code Extensions:

$Extensions = @(
    
    "AzurePolicy.azurepolicyextension",
    "ms-azuretools.vscode-azureresourcegroups",
    "ms-azuretools.vscode-azurestorage",
    "ms-azuretools.vscode-azurevirtualmachines",
    "ms-azuretools.vscode-bicep",
    "ms-azuretools.vscode-docker",
    "ms-dotnettools.vscode-dotnet-runtime",
    "ms-vscode.remote-server",
    "ms-vscode.remote-explorer",
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode-remote.vscode-remote-extensionpack",
    "ms-vscode.azure-account",
    "ms-vscode.azurecli",
    "ms-vscode.powershell",
    "ms-vscode.vscode-node-azure-pack",
    "github.copilot"   
)

$Extensions | ForEach-Object { 

    Start-Process -FilePath "code" -ArgumentList "--install-extension $_ --force" -Wait -NoNewWindow
}
