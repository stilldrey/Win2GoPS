Get-Disk
$disknumber = Read-Host 'What Disk would you like to COMPLETELY DELETE and REPARTITION for Windows To Go?'
"you have picked disk $disknumber"
“press CTRL + C to break out otherwise”
pause
$disk = Get-Disk $disknumber
Clear-Disk -InputObject $disk -RemoveData 
Initialize-Disk -InputObject $disk -PartitionStyle MBR 
$SystemPartition = New-Partition -InputObject $disk -Size (350MB) -IsActive 
Format-Volume -NewFileSystemLabel "UFD-System" -FileSystem FAT32 -Partition $SystemPartition 
$OSPartition = New-Partition -InputObject $disk -UseMaximumSize 
Format-Volume -NewFileSystemLabel "WTG-Windows10" -FileSystem NTFS -Partition $OSPartition 
Set-Partition -InputObject $SystemPartition -NewDriveLetter "Y" 
Set-Partition -InputObject $OSPartition -NewDriveLetter "Z" 
Get-WindowsImage -ImagePath d:\sources\install.wim 
dism /apply-image /imagefile:d:\sources\install.wim /index:1 /applydir:Z:\ 
BCDBOOT Z:\Windows /f ALL /s Y:

