function get-sysinfo{
    $sys_desc = Get-CIMInstance win32_computersystem | Select-Object Description
    $sys_desc.PSObject.Properties | ForEach-Object {
        $name = $_.Name
        if($_.Value -eq $null){ $sys_desc.$name = "Data unavailable"}
    }

    write-output "____________________________"
    write-output "System Hardware information"
    write-output "___________________________"
    $sys_desc |format-list
    write-output ""

}

function get-osinfo{
    $os_desc =  Get-CIMInstance win32_operatingsystem | Select-Object Name, Version
    $os_desc.PSObject.Properties | ForEach-Object {
        $name = $_.Name
        if($_.Value -eq $null){ $os_desc.$name = "Data unavailable"}
    }
    write-output "____________________________"
    write-output "Operating system information"
    write-output "____________________________"
    $os_desc |format-list
    write-output ""
}

function get-processorinfo{
    $processor_desc = Get-CIMInstance win32_processor | 
    foreach{
        new-object -typename psobject -property @{
            
            CurrentClockSpeed = $_.CurrentClockSpeed
            NumberOfCores = $_.NumberOfCores
            L1CacheSize = $_.L1CacheSize
            L2CacheSize = $_.L2CacheSize
            L3CacheSize = $_.L3CacheSize
            
        }            
    }
    $processor_desc.PSObject.Properties | ForEach-Object {
        $name = $_.Name
        if($_.Value -eq $null){ $processor_desc.$name = "Data unavailable"}
    }
    write-output "_____________________"
    write-output "Processor information"
    write-output "_____________________"
    $processor_desc |format-list
    write-output ""
}

function get-memoryinfo{
    $totalcapacity = 0
    write-output "_____________________"
    write-output "Memory information"
    write-output "_____________________"
    $mem_info = get-wmiobject -class win32_physicalmemory |
    foreach {
        new-object -TypeName psobject -Property @{
            Manufacturer = $_.manufacturer
            "Speed(MHz)" = $_.speed
            "Size(MB)" = $_.capacity/1mb
            Bank = $_.banklabel
            Slot = $_.devicelocator
        }
        $totalcapacity += $_.capacity/1mb
    } 
    $mem_info.PSObject.Properties | ForEach-Object {
        $name = $_.Name
        if($_.Value -eq $null){ $mem_info.$name = "Data unavailable"}
    }
    $mem_info |ft -auto Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot
    "Total RAM: ${totalcapacity}MB "
    write-output ""
}
function get-physicaldiskinfo{
    $drives = Get-CIMInstance CIM_diskdrive
    write-output "__________________________"
    write-output "Physical disks information"
    write-output "__________________________"
    $disk_info = foreach ($drive in $drives) {
        $partitions = $drive | get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                new-object -typename psobject -property @{
                    Manufacturer=$drive.Manufacturer
                    Location=$partition.deviceid
                    Drive=$logicaldisk.deviceid
                    "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                }
           }
        }
    }
    $disk_info.PSObject.Properties | ForEach-Object {
        $name = $_.Name
        if($_.Value -eq $null){ $disk_info.$name = "Data unavailable"}
    }
    $disk_info
    write-output ""
}

function get-networkinfo{
    $script = $PSScriptRoot+"\get_networkinfo.ps1"
    $network_desc = &$script
    $network_desc.PSObject.Properties | ForEach-Object {
        $name = $_.Name
        if($_.Value -eq $null){ $network_desc.$name = "Data unavailable"}
    }
    write-output "___________________"
    write-output "Network information"
    write-output "___________________"
    write-output $network_desc
    write-output ""
}
function get-videoinfo{
    $disk_info = Get-CIMInstance win32_videocontroller | Select-Object CurrentHorizontalResolution, CurrentVerticalResolution, Description
    write-output "" "____________________________"
    write-output "Video card information"
    write-output "____________________________"
    write-output  "Resolution  :  $($disk_info.CurrentHorizontalResolution) X $($disk_info.CurrentVerticalResolution) "
    write-output ""
}

get-sysinfo
get-osinfo
get-processorinfo
get-memoryinfo
get-physicaldiskinfo
get-networkinfo
get-videoinfo