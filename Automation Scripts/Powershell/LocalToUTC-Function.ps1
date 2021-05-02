
function Convert-LocalToUTC {
    param( [parameter(Mandatory = $true)] [String] $ISTTime )

    $strCurrentTimeZone = (Get-WmiObject win32_timezone).StandardName 
    $TZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTimeZone) 
    $UTCTime = [System.TimeZoneInfo]::ConvertTimeToUtc($ISTTime, $TZ) 
    return $UTCTime
}

Convert-LocalToUTC "11:51"  #Expected 6:21:00

#RemoteJob Example

Invoke-Command -ComputerName DS-204 -ScriptBlock {Get-EventLog System} -AsJob