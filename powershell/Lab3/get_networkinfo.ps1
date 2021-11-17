function get-networkinfo{
    $ipenabled = get-ciminstance win32_networkadapterconfiguration | where IPEnabled -eq 'True' 
    $ipenabled | Select-Object Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder | format-table
}