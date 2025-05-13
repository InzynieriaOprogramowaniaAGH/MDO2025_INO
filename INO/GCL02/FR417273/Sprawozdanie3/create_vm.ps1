# Vars
$vmName     = "fedora-auto"
$isoPath    = "D:\System ISOs\kickstart\burned\Fedora-Kickstart.iso"
$diskFolder = "C:\Users\Filip\VirtualBox VMs\$vmName"
$diskPath   = "$diskFolder\$vmName.vdi"
$VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$memory     = 2048
$cpus       = 1

# Create VM
& $VBoxManage createvm --name $vmName --ostype Fedora_64 --register

# Config VM
& $VBoxManage modifyvm $vmName --memory $memory --cpus $cpus --boot1 dvd --firmware efi

# Create Disk
New-Item -ItemType Directory -Path $diskFolder -Force | Out-Null
& $VBoxManage createhd --filename "$diskPath" --size 2000

# Add controllers
& $VBoxManage storagectl $vmName --name "SATA Controller" --add sata --controller IntelAhci
& $VBoxManage storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$diskPath"

& $VBoxManage storagectl $vmName --name "IDE Controller" --add ide
& $VBoxManage storageattach $vmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$isoPath"

# Start VM
& $VBoxManage startvm $vmName --type gui

