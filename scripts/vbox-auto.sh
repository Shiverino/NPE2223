#!/bin/bash

# VM name and OS version
VM_NAME="Debian_NPE13"
OS_TYPE="Debian_64"

VM_NAME_2="Kali_Client_NPE6"

# VM memory and CPU settings
VM_MEMORY="2048"
VM_CPUS="4"

# Hard drive settings
#VDI_PATH_2="/Users/sasuke/Downloads/64bit 15/Kali Linux 2022.3 (64bit).vdi"
#ijn


read -r -p "Enter the path to the vdi file for debian server: " VDI_PATH

read -r -p "Enter the path to the vdi file for kali server: " VDI_PATH_2

# Create the virtual machine
VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register

# Set the memory and CPU settings
VBoxManage modifyvm "$VM_NAME" --memory "$VM_MEMORY" --cpus "$VM_CPUS"

# Attach the virtual hard drive to the virtual machine
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VDI_PATH"

# Adding NIC2 intnet to the virtual machine

vboxmanage modifyvm "$VM_NAME" --nic2 intnet --intnet2 "NPE"

# Change VRAM
VBoxManage modifyvm "$VM_NAME" --vram 256



# Add Shared Folder
printf 'Creating Shared Folder...\n'

[[ -d "${HOME}/Shared_NPE" ]] || {
    printf 'Shared folder not found. Creating Shared folder...\n'
    mkdir -p "${HOME}/Shared_NPE"
}
vboxmanage sharedfolder add "${VM_NAME}" --name "Shared" --hostpath "${HOME}/Shared_NPE" --automount

# Run Scripts on launch VM
vboxmanage guestcontrol "$VM_NAME" run --exe "apache-tomcat.sh"

# Start the virtual machine
VBoxManage startvm "$VM_NAME" 



# Create the virtual machine
VBoxManage createvm --name "$VM_NAME_2" --ostype "$OS_TYPE" --register

# Set the memory and CPU settings
VBoxManage modifyvm "$VM_NAME_2" --memory "$VM_MEMORY" --cpus "$VM_CPUS"

# Attach the virtual hard drive to the virtual machine
VBoxManage storagectl "$VM_NAME_2" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$VM_NAME_2" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VDI_PATH_2"

# Adding NIC2 intnet to the virtual machine
vboxmanage modifyvm "$VM_NAME_2" --nic2 intnet --intnet2 "NPE"

VBoxManage modifyvm "$VM_NAME_2" --graphicscontroller "VMSVGA"
# Change VRAM
VBoxManage modifyvm "$VM_NAME_2" --vram 256

# Start the virtual machine
#VBoxManage startvm "$VM_NAME_2" 


