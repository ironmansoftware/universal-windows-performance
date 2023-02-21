New-UDDashboard -Title 'PowerShell Universal' -Content {
    New-UDDynamic -Content {
        $Data = Get-PSUScript -Name 'Windows Performance\CollectStats.ps1' -Integrated | Get-PSUJob -Integrated -OrderBy EndTime -OrderDirection Descending -First 10 | Get-PSUJobPipelineOutput -Integrated | Sort-Object -Property Timestamp 
        New-UDLayout -Columns 4 -Content {
            # CPU 
            New-UDCard -Title 'CPU (%)' -Content {
                $ChartData = $Data | ForEach-Object {
                    @{
                        Timestamp      = (($_.Timestamp) - (Get-Date)).TotalSeconds.ToString("0")
                        LoadPercentage = $_.CPU.LoadPercentage
                    }
                } 
                New-UDChartJS -Type 'line' -Data $ChartData -DataProperty LoadPercentage -LabelProperty Timestamp
            }

            # Network

            $Data.Network | Group-Object -Property Name | ForEach-Object {
                New-UDCard -Title $_.Name -Content {
                    $ReceivedBytes = New-UDChartJSDataset -DataProperty ReceivedBytes -Label 'Received Bytes' -BackgroundColor '#126f8c' -BorderColor '#126f8c' -BorderWidth 1
                    $SentBytes = New-UDChartJSDataset -DataProperty SentBytes -Label 'SentBytes' -BackgroundColor '#8da322' -BorderColor '#8da322' -BorderWidth 1

                    $Options = @{
                        Type          = 'line'
                        Data          = $_.Group
                        Dataset       = @($ReceivedBytes, $SentBytes)
                        LabelProperty = "Name"
                    }

                    New-UDChartJS @Options
                }
            }

            # Drives 

            $Data.Drives | Group-Object -Property Name | ForEach-Object {
                New-UDCard -Title $_.Name -Content {
                    $Free = New-UDChartJSDataset -DataProperty Free -Label 'Free' -BackgroundColor '#126f8c' -BorderColor '#126f8c' -BorderWidth 1
                    $Used = New-UDChartJSDataset -DataProperty Used -Label 'Used' -BackgroundColor '#8da322' -BorderColor '#8da322' -BorderWidth 1

                    $Options = @{
                        Type          = 'line'
                        Data          = $_.Group
                        Dataset       = @($Free, $Used)
                        LabelProperty = "Name"
                    }

                    New-UDChartJS @Options
                }
            }

            # OS 
            New-UDCard -Title 'Free Physical Memory (GB)' -Content {
                $ChartData = $Data | ForEach-Object {
                    @{
                        Timestamp      = (($_.Timestamp) - (Get-Date)).TotalSeconds.ToString("0")
                        FreePhysicalMemory = $_.OS.FreePhysicalMemory / 1MB
                    }
                } 
                New-UDChartJS -Type 'line' -Data $ChartData -DataProperty FreePhysicalMemory -LabelProperty Timestamp
            }

        }
    } -AutoRefresh -AutoRefreshInterval 10
}