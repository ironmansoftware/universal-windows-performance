[PSCustomObject]@{
    Timestamp = Get-Date
    Network = Get-NetAdapterStatistics
    Drives = Get-PSDrive -PSProvider FileSystem
    CPU = (Get-CimInstance Win32_Processor)
    OS = Get-CimInstance Win32_OperatingSystem
}