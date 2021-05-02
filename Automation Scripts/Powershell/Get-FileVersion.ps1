param( [parameter(Mandatory = $True)] [String] $Path, [parameter(Mandatory=$True)] [String] $FileName )
function Get-FileSizeKB() {
    param( [parameter(Mandatory=$true)] [int] $FileSize)
    [string]::Format("{0:0}KB", [math]::round($FileSize /1KB)) 
}
function Get-FileVersion {
    param([string]$Path, [string]$FileName) {
    }
    if ($Path -eq $null) {
        $Path = (Get-Location).Path
    }
    Get-ChildItem -Path $Path -Recurse | Where-Object { ($_.PSIsContainer -eq $False) -and ($_.Name -like "$FileName") } | Select-Object VersionInfo,  @{ expression={$_.LastWriteTime}; label='DateModified' },@{ expression={Get-FileSizeKB($_.Length)}; label='Length' }  -ExpandProperty VersionInfo | Format-Table FileName,Length, FileVersion, ProductVersion, DateModified -Wrap -AutoSize | Out-File -Width 4096 C:\File-Version-Report.csv
}

#Function Call
#Get-FileVersion -Path "C:\SkillSurvey\app\"  -FileName "SkillSurvey.ProductLine.dll"

Get-FileVersion -Path $Path -FileName $FileName