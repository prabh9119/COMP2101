function get-mydisks{
    $disk_info = new-object -typename psobject -property @{
        Manufacturer =  (get-disk).Manufacturer;
        SerialNo =  (get-disk).SerialNumber;
        FirmwareVersion = (get-disk).FirmwareVersion;
        Size = (get-disk).Size
    }
    write-output $disk_info | format-table -autosize
}