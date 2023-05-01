#!/bin/bash

# VM name and OS version
VM_NAME="DebianServer"
OS_TYPE="Debian_64"

VM_NAME_2="KaliClient"

# VM memory and CPU settings
VM_MEMORY="2048"
VM_CPUS="4"

# Hard drive settings
#VDI_PATH="/Users/sasuke/Downloads/64bit 3/Kali Linux 2022.3 (64bit).vdi"
#VDI_PATH_2="/Users/sasuke/Downloads/64bit 10/Debian 10 CLI (64bit).vdi"

read -r -p "Enter the path to the vdi file for debian server: " VDI_PATH

read -r -p "Enter the path to the vdi file for kali server: " VDI_PATH_2




# Create the virtual machine
VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register

# Set the memory and CPU settings
VBoxManage modifyvm "$VM_NAME" --memory "$VM_MEMORY" --cpus "$VM_CPUS"

# Attach the virtual hard drive to the virtual machine
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VDI_PATH"

# Attach the ISO image to the virtual machine
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide

# Change VRAM
VBoxManage modifyvm "$VM_NAME" --vram 128

# Start the virtual machine
VBoxManage startvm "$VM_NAME" 



# Create the virtual machine
VBoxManage createvm --name "$VM_NAME_2" --ostype "$OS_TYPE" --register

# Set the memory and CPU settings
VBoxManage modifyvm "$VM_NAME_2" --memory "$VM_MEMORY" --cpus "$VM_CPUS"

# Attach the virtual hard drive to the virtual machine
VBoxManage storagectl "$VM_NAME_2" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$VM_NAME_2" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VDI_PATH_2"

# Attach the ISO image to the virtual machine
VBoxManage storagectl "$VM_NAME_2" --name "IDE Controller" --add ide


# Change VRAM
VBoxManage modifyvm "$VM_NAME_2" --vram 128

# Start the virtual machine
VBoxManage startvm "$VM_NAME_2" 


