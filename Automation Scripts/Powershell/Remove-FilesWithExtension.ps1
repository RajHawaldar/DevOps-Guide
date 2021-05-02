param( [parameter(Mandatory = $True)] [String] $Path, [parameter(Mandatory=$True)] [String] $Extension )

function Remove-FileWithExtension() {
    param([Parameter(Mandatory = $True)][String] $Path, [Parameter(Mandatory = $True)][String] $Extension)

    if ( ( Get-ChildItem -Path $Path -Recurse | Where-Object Extension -eq "$Extension" | Measure-Object).Count -ne 0) {
        Get-ChildItem -Path $Path -Recurse | Where-Object Extension -eq "$Extension" 
        $UserInput = Read-Host  -Prompt "Do you want to delete files(y/Y)"
        if ($UserInput -eq "y") {
            Get-ChildItem -Path $Path -Recurse | Where-Object Extension -eq "$Extension" | Remove-Item
        }
    }
    else {
        Write-Host "No Files Found with the Extension '$Extension'!"
    }
}

# Remove-FileWithExtension -Path "E:\" -Extension ".pdb"
Remove-FileWithExtension -Path $Path -Extension $Extension