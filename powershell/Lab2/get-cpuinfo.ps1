function get-cpuinfo{

    $cpu_info = get-ciminstance cim_processor | Select-Object Manufacturer, PartNumber, NumberOfCores, MaxClockSpeed, CurrentClockSpeed | format-list
    write-output $cpu_info
    write-output ''
}