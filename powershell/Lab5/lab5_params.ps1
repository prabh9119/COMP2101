param ($System, $Disks, $Network)

if ($System){
    get-sysinfo
    get-osinfo
    get-processorinfo
    get-videoinfo
}
if ($Disks){
    get-memoryinfo
    get-physicaldiskinfo   
}
if($Network){
    get-networkinfo
}
if ( !($System) -and !($Disks) -and  !($Network)){
    get-sysinfo
    get-osinfo
    get-processorinfo
    get-videoinfo
    get-memoryinfo
    get-physicaldiskinfo 
    get-networkinfo
}
